package com.generatorproject.services;

import com.generatorproject.dao.TechnicianCapabilityDAO;
import com.generatorproject.model.Incident;
import com.generatorproject.model.IncidentPlanRecommendationView;
import com.generatorproject.model.Product;
import com.generatorproject.model.RequiredSkillSuggestion;
import com.generatorproject.model.TechnicianSuggestion;
import com.generatorproject.model.Users;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

public class IncidentPlanRecommendationService {
    private final TechnicianCapabilityDAO technicianCapabilityDAO;
    private final IUserServices userServices;
    private static final Map<String, Set<String>> REQUIRED_SKILL_ALIASES = createRequiredSkillAliases();

    public IncidentPlanRecommendationService() {
        this.technicianCapabilityDAO = new TechnicianCapabilityDAO();
        this.userServices = new UserServices();
    }

    public List<IncidentPlanRecommendationView> buildRecommendations(Incident incident, Product product) {
        if (incident == null) {
            return Collections.emptyList();
        }

        List<RecommendationSeed> seeds = createSeeds(incident, product);
        if (seeds.isEmpty()) {
            return Collections.emptyList();
        }

        List<Users> technicians = userServices.findUserByRoleId(4);
        List<Integer> technicianIds = new ArrayList<>();
        for (Users technician : technicians) {
            technicianIds.add(technician.getId());
        }

        Timestamp referenceStart = resolveReferenceStart(incident);
        Timestamp referenceEnd = resolveReferenceEnd(incident, referenceStart);
        java.sql.Date referenceDate = new java.sql.Date(referenceStart.getTime());

        Map<Integer, TechnicianCapabilityDAO.TechnicianProfileSnapshot> profiles = technicianCapabilityDAO.findProfiles(technicianIds);
        Map<Integer, Set<String>> skillsByTechnician = technicianCapabilityDAO.findTechnicianSkillCodes(technicianIds);
        Map<Integer, Boolean> unavailableByTechnician = technicianCapabilityDAO.findUnavailability(technicianIds, referenceStart, referenceEnd);
        Map<Integer, Integer> taskCounts = technicianCapabilityDAO.countTasksPerDay(technicianIds, referenceDate);

        List<String> allSkillCodes = new ArrayList<>();
        for (RecommendationSeed seed : seeds) {
            for (RequiredSkillSuggestion skill : seed.requiredSkills) {
                allSkillCodes.add(skill.getSkillCode());
            }
        }
        Map<String, String> skillNames = technicianCapabilityDAO.findSkillNames(allSkillCodes);

        List<IncidentPlanRecommendationView> results = new ArrayList<>();
        int index = 1;
        for (RecommendationSeed seed : seeds) {
            List<RequiredSkillSuggestion> normalizedSkills = new ArrayList<>();
            for (RequiredSkillSuggestion skill : seed.requiredSkills) {
                String displayName = skillNames.containsKey(skill.getSkillCode()) ? skillNames.get(skill.getSkillCode()) : skill.getSkillName();
                normalizedSkills.add(new RequiredSkillSuggestion(skill.getSkillCode(), displayName, skill.getImportanceLevel(), skill.getReason()));
            }
            List<TechnicianSuggestion> technicianSuggestions = buildTechnicianSuggestions(
                    technicians,
                    profiles,
                    skillsByTechnician,
                    unavailableByTechnician,
                    taskCounts,
                    normalizedSkills,
                    1,
                    referenceStart,
                    referenceEnd,
                    seed.recommendedServiceLocation,
                    5
            );

            results.add(new IncidentPlanRecommendationView(
                    "REC-" + incident.getId() + "-" + index,
                    seed.title,
                    seed.recommendedWorkType,
                    seed.recommendedPriority,
                    seed.recommendedDurationMinutes,
                    1,
                    seed.requiresPartsPreparation,
                    seed.recommendedServiceLocation,
                    seed.recommendedPartsNote,
                    seed.reasonSummary,
                    seed.confidenceScore,
                    normalizedSkills,
                    technicianSuggestions
            ));
            index++;
        }
        return results;
    }

    private List<TechnicianSuggestion> buildTechnicianSuggestions(List<Users> technicians,
                                                                  Map<Integer, TechnicianCapabilityDAO.TechnicianProfileSnapshot> profiles,
                                                                  Map<Integer, Set<String>> skillsByTechnician,
                                                                  Map<Integer, Boolean> unavailableByTechnician,
                                                                  Map<Integer, Integer> taskCounts,
                                                                  List<RequiredSkillSuggestion> requiredSkills,
                                                                  int recommendedTechnicianCount,
                                                                  Timestamp referenceStart,
                                                                  Timestamp referenceEnd,
                                                                  String serviceLocation,
                                                                  int maxSuggestions) {
        List<TechnicianSuggestion> suggestions = new ArrayList<>();
        Set<String> requiredSkillCodes = new HashSet<String>();
        for (RequiredSkillSuggestion skill : requiredSkills) {
            if ("REQUIRED".equalsIgnoreCase(skill.getImportanceLevel())) {
                requiredSkillCodes.add(skill.getSkillCode());
            }
        }

        for (Users technician : technicians) {
            TechnicianCapabilityDAO.TechnicianProfileSnapshot profile = profiles.get(technician.getId());
            Set<String> technicianSkills = skillsByTechnician.getOrDefault(technician.getId(), Collections.<String>emptySet());
            boolean unavailable = unavailableByTechnician.containsKey(technician.getId());
            boolean missingRequiredSkill = !hasAllRequiredSkills(technicianSkills, requiredSkillCodes);
            if (missingRequiredSkill) {
                continue;
            }
            boolean outOfWorkingHours = isOutOfWorkingHours(profile, referenceStart, referenceEnd);
            boolean overloaded = isOverloaded(profile, taskCounts.get(technician.getId()));

            int score = 100;
            if (profile == null || !profile.isActive()) {
                score -= 40;
            }
            if (unavailable) {
                score -= 30;
            }
            if (outOfWorkingHours) {
                score -= 15;
            }
            if (overloaded) {
                score -= 15;
            }
            if (profile != null && profile.getServiceArea() != null && serviceLocation != null
                    && !serviceLocation.trim().isEmpty()
                    && !profile.getServiceArea().toLowerCase(Locale.ROOT).contains(serviceLocation.toLowerCase(Locale.ROOT))) {
                score -= 10;
            }
            if (recommendedTechnicianCount >= 1) {
                score += 3;
            }
            if (score < 0) {
                score = 0;
            }

            suggestions.add(new TechnicianSuggestion(
                    technician.getId(),
                    technician.getFullName(),
                    score,
                    unavailable,
                    outOfWorkingHours,
                    overloaded,
                    missingRequiredSkill,
                    buildSummary(profile, missingRequiredSkill, unavailable, outOfWorkingHours, overloaded, technicianSkills, requiredSkillCodes)
            ));
        }

        suggestions.sort(Comparator.comparingInt(TechnicianSuggestion::getMatchScore).reversed());
        if (maxSuggestions > 0 && suggestions.size() > maxSuggestions) {
            return new ArrayList<TechnicianSuggestion>(suggestions.subList(0, maxSuggestions));
        }
        return suggestions;
    }

    private boolean hasAllRequiredSkills(Set<String> technicianSkills, Set<String> requiredSkillCodes) {
        if (requiredSkillCodes == null || requiredSkillCodes.isEmpty()) {
            return true;
        }
        Set<String> normalizedTechnicianSkills = new HashSet<String>();
        if (technicianSkills != null) {
            for (String skill : technicianSkills) {
                if (skill != null) {
                    normalizedTechnicianSkills.add(skill.trim().toUpperCase(Locale.ROOT));
                }
            }
        }

        for (String requiredSkill : requiredSkillCodes) {
            if (requiredSkill == null) {
                continue;
            }
            String normalizedRequired = requiredSkill.trim().toUpperCase(Locale.ROOT);
            Set<String> aliases = REQUIRED_SKILL_ALIASES.getOrDefault(normalizedRequired, Collections.singleton(normalizedRequired));
            boolean matched = false;
            for (String alias : aliases) {
                if (normalizedTechnicianSkills.contains(alias)) {
                    matched = true;
                    break;
                }
            }
            if (!matched) {
                return false;
            }
        }
        return true;
    }

    private static Map<String, Set<String>> createRequiredSkillAliases() {
        Map<String, Set<String>> aliases = new HashMap<>();
        aliases.put("CONSUMABLE_REPLACEMENT", new HashSet<String>(Arrays.asList(
                "CONSUMABLE_REPLACEMENT",
                "COMPONENTS_AND_SUPPLIES",
                "SPARE_PART_REPLACEMENT"
        )));
        aliases.put("DIESEL_ENGINE_REPAIR", new HashSet<String>(Arrays.asList(
                "DIESEL_ENGINE_REPAIR",
                "ENGINE_SPECIALIST",
                "ENGINE_MECHANICS_SPECIALIST"
        )));
        aliases.put("FIELD_INSPECTION", new HashSet<String>(Arrays.asList(
                "FIELD_INSPECTION",
                "SITE_SURVEY"
        )));
        return aliases;
    }

    public List<TechnicianSuggestion> buildTechnicianRanking(Incident incident,
                                                             Product product,
                                                             Timestamp referenceStart,
                                                             Timestamp referenceEnd) {
        if (incident == null) {
            return Collections.emptyList();
        }

        List<RecommendationSeed> seeds = createSeeds(incident, product);
        if (seeds.isEmpty()) {
            return Collections.emptyList();
        }

        RecommendationSeed seed = seeds.get(0);
        List<Users> technicians = userServices.findUserByRoleId(4);
        List<Integer> technicianIds = new ArrayList<>();
        for (Users technician : technicians) {
            technicianIds.add(technician.getId());
        }

        Timestamp rankingStart = referenceStart == null ? resolveReferenceStart(incident) : referenceStart;
        Timestamp rankingEnd = referenceEnd == null ? resolveReferenceEnd(incident, rankingStart) : referenceEnd;
        java.sql.Date referenceDate = new java.sql.Date(rankingStart.getTime());

        Map<Integer, TechnicianCapabilityDAO.TechnicianProfileSnapshot> profiles = technicianCapabilityDAO.findProfiles(technicianIds);
        Map<Integer, Set<String>> skillsByTechnician = technicianCapabilityDAO.findTechnicianSkillCodes(technicianIds);
        Map<Integer, Boolean> unavailableByTechnician = technicianCapabilityDAO.findUnavailability(technicianIds, rankingStart, rankingEnd);
        Map<Integer, Integer> taskCounts = technicianCapabilityDAO.countTasksPerDay(technicianIds, referenceDate);

        return buildTechnicianSuggestions(
                technicians,
                profiles,
                skillsByTechnician,
                unavailableByTechnician,
                taskCounts,
                seed.requiredSkills,
                1,
                rankingStart,
                rankingEnd,
                seed.recommendedServiceLocation,
                0
        );
    }

    private boolean isOutOfWorkingHours(TechnicianCapabilityDAO.TechnicianProfileSnapshot profile, Timestamp referenceStart, Timestamp referenceEnd) {
        if (profile == null || profile.getWorkingHoursStart() == null || profile.getWorkingHoursEnd() == null) {
            return false;
        }
        Timestamp workStart = Timestamp.valueOf(referenceStart.toLocalDateTime().toLocalDate().atTime(profile.getWorkingHoursStart().toLocalTime()));
        Timestamp workEnd = Timestamp.valueOf(referenceStart.toLocalDateTime().toLocalDate().atTime(profile.getWorkingHoursEnd().toLocalTime()));
        return referenceStart.before(workStart) || referenceEnd.after(workEnd);
    }

    private boolean isOverloaded(TechnicianCapabilityDAO.TechnicianProfileSnapshot profile, Integer currentTasks) {
        return profile != null && profile.getMaxTasksPerDay() != null && currentTasks != null && currentTasks >= profile.getMaxTasksPerDay();
    }

    private String buildSummary(TechnicianCapabilityDAO.TechnicianProfileSnapshot profile,
                                boolean missingRequiredSkill,
                                boolean unavailable,
                                boolean outOfWorkingHours,
                                boolean overloaded,
                                Set<String> technicianSkills,
                                Set<String> requiredSkills) {
        List<String> notes = new ArrayList<String>();
        if (profile == null || !profile.isActive()) {
            notes.add("Profile chưa active");
        }
        if (missingRequiredSkill) {
            notes.add("Thiếu kỹ năng bắt buộc");
        } else if (!requiredSkills.isEmpty()) {
            notes.add("Đủ kỹ năng chính");
        }
        if (unavailable) {
            notes.add("Đang bị block / nghỉ / training");
        }
        if (outOfWorkingHours) {
            notes.add("Ngoài giờ làm việc cấu hình");
        }
        if (overloaded) {
            notes.add("Đã chạm max task trong ngày");
        }
        if (notes.isEmpty()) {
            notes.add("Phù hợp để phân công");
        }
        return String.join(" • ", notes);
    }

    private Timestamp resolveReferenceStart(Incident incident) {
        if (incident.getPreferredDate() != null && incident.getPreferredTimeFrom() != null) {
            return Timestamp.valueOf(incident.getPreferredDate().toLocalDate().atTime(incident.getPreferredTimeFrom().toLocalTime()));
        }
        if (incident.getPreferredDate() != null) {
            return Timestamp.valueOf(incident.getPreferredDate().toLocalDate().atTime(8, 0));
        }
        return new Timestamp(System.currentTimeMillis());
    }

    private Timestamp resolveReferenceEnd(Incident incident, Timestamp referenceStart) {
        if (incident.getPreferredDate() != null && incident.getPreferredTimeTo() != null) {
            return Timestamp.valueOf(incident.getPreferredDate().toLocalDate().atTime(incident.getPreferredTimeTo().toLocalTime()));
        }
        return new Timestamp(referenceStart.getTime() + 2L * 60 * 60 * 1000);
    }

    private List<RecommendationSeed> createSeeds(Incident incident, Product product) {
        String issueType = incident.getTitle() == null ? "" : incident.getTitle().toUpperCase(Locale.ROOT);
        String location = incident.getLocationSnapshot() == null && product != null ? product.getCurrentLocation() : incident.getLocationSnapshot();
        List<RecommendationSeed> seeds = new ArrayList<RecommendationSeed>();

        List<RequiredSkillSuggestion> inspectionSkills = Arrays.asList(
                new RequiredSkillSuggestion("FIELD_INSPECTION", "Khảo sát hiện trường", "REQUIRED", "Cần xác minh hiện trạng thiết bị"),
                new RequiredSkillSuggestion("ELECTRICAL_DIAGNOSTICS", "Chẩn đoán điện", "PREFERRED", "Phù hợp các lỗi điều khiển / cảnh báo")
        );
        List<RequiredSkillSuggestion> repairSkills = Arrays.asList(
                new RequiredSkillSuggestion("DIESEL_ENGINE_REPAIR", "Sửa chữa động cơ diesel", "REQUIRED", "Phù hợp cho lỗi hư hỏng / thay thế"),
                new RequiredSkillSuggestion("SAFETY_LOCKOUT", "An toàn lockout", "PREFERRED", "Đảm bảo an toàn khi can thiệp thiết bị")
        );
        List<RequiredSkillSuggestion> replacementSkills = Arrays.asList(
                new RequiredSkillSuggestion("CONSUMABLE_REPLACEMENT", "Thay thế linh kiện / vật tư", "REQUIRED", "Ưu tiên cho case thay ắc quy, thay linh kiện hư hỏng"),
                new RequiredSkillSuggestion("ELECTRICAL_DIAGNOSTICS", "Chẩn đoán điện", "PREFERRED", "Đánh giá mạch nạp/xả trước và sau thay thế"),
                new RequiredSkillSuggestion("SAFETY_LOCKOUT", "An toàn lockout", "PREFERRED", "Đảm bảo cô lập nguồn trước khi thay linh kiện")
        );
        List<RequiredSkillSuggestion> periodicSkills = Arrays.asList(
                new RequiredSkillSuggestion("PREVENTIVE_MAINTENANCE", "Bảo trì định kỳ", "REQUIRED", "Phù hợp cho checklist bảo dưỡng"),
                new RequiredSkillSuggestion("CONSUMABLE_REPLACEMENT", "Thay thế vật tư tiêu hao", "PREFERRED", "Chuẩn bị lọc, dầu, dây curoa")
        );

        boolean replacementContext = issueType.contains("ẮC QUY")
                || issueType.contains("BATTERY")
                || issueType.contains("LINH KIỆN")
                || issueType.contains("THAY THẾ")
                || issueType.contains("REPLACEMENT")
                || issueType.contains("PHỤ TÙNG");
        String correctiveWorkType = replacementContext ? "REPLACEMENT" : "REPAIR";
        List<RequiredSkillSuggestion> correctiveSkills = replacementContext ? replacementSkills : repairSkills;
        String correctivePartsNote = replacementContext
                ? "Chuẩn bị linh kiện thay thế (ví dụ ắc quy/phụ tùng), vật tư tiêu hao và kiểm tra tương thích trước khi lắp."
                : "Chuẩn bị vật tư thay thế cơ bản và kỹ thuật viên có kinh nghiệm sửa chữa máy phát.";
        String correctiveReasonSummary = replacementContext
                ? "Phù hợp khi thiết bị cần thay thế linh kiện (ắc quy/phụ tùng) sau khi xác minh hư hỏng."
                : "Phù hợp khi thiết bị có dấu hiệu hỏng rõ ràng hoặc cần thay thế linh kiện.";

        seeds.add(new RecommendationSeed(
                "Khảo sát trước khi xử lý",
                "INSPECTION",
                defaultPriority(incident.getUrgencyLevel()),
                120,
                1,
                false,
                location,
                "Kiểm tra tình trạng thiết bị, ghi nhận lỗi và xác minh nguyên nhân gốc.",
                "Ưu tiên khảo sát để chốt đúng nguyên nhân và tránh báo sai vật tư.",
                82,
                inspectionSkills
        ));

        seeds.add(new RecommendationSeed(
                "Phương án sửa chữa / thay thế",
                correctiveWorkType,
                upgradePriority(defaultPriority(incident.getUrgencyLevel())),
                180,
                1,
                true,
                location,
                correctivePartsNote,
                correctiveReasonSummary,
                88,
                correctiveSkills
        ));

        if (issueType.contains("BẢO") || issueType.contains("MAINTENANCE") || issueType.contains("ĐỊNH KỲ")) {
            seeds.add(new RecommendationSeed(
                    "Phương án bảo trì định kỳ",
                    "PERIODIC",
                    "MEDIUM",
                    120,
                    1,
                    true,
                    location,
                    "Chuẩn bị checklist bảo trì, dầu nhớt, lọc gió/lọc dầu nếu cần.",
                    "Phù hợp với yêu cầu bảo trì định kỳ hoặc kiểm tra theo chu kỳ sử dụng.",
                    85,
                    periodicSkills
            ));
        }
        return seeds;
    }

    private String defaultPriority(String urgencyLevel) {
        if (urgencyLevel == null || urgencyLevel.trim().isEmpty()) {
            return "MEDIUM";
        }
        return urgencyLevel.trim().toUpperCase(Locale.ROOT);
    }

    private String upgradePriority(String priority) {
        if ("LOW".equals(priority)) {
            return "MEDIUM";
        }
        if ("MEDIUM".equals(priority)) {
            return "HIGH";
        }
        return priority;
    }

    private static class RecommendationSeed {
        private final String title;
        private final String recommendedWorkType;
        private final String recommendedPriority;
        private final int recommendedDurationMinutes;
        private final int recommendedTechnicianCount;
        private final boolean requiresPartsPreparation;
        private final String recommendedServiceLocation;
        private final String recommendedPartsNote;
        private final String reasonSummary;
        private final int confidenceScore;
        private final List<RequiredSkillSuggestion> requiredSkills;

        private RecommendationSeed(String title,
                                   String recommendedWorkType,
                                   String recommendedPriority,
                                   int recommendedDurationMinutes,
                                   int recommendedTechnicianCount,
                                   boolean requiresPartsPreparation,
                                   String recommendedServiceLocation,
                                   String recommendedPartsNote,
                                   String reasonSummary,
                                   int confidenceScore,
                                   List<RequiredSkillSuggestion> requiredSkills) {
            this.title = title;
            this.recommendedWorkType = recommendedWorkType;
            this.recommendedPriority = recommendedPriority;
            this.recommendedDurationMinutes = recommendedDurationMinutes;
            this.recommendedTechnicianCount = recommendedTechnicianCount;
            this.requiresPartsPreparation = requiresPartsPreparation;
            this.recommendedServiceLocation = recommendedServiceLocation;
            this.recommendedPartsNote = recommendedPartsNote;
            this.reasonSummary = reasonSummary;
            this.confidenceScore = confidenceScore;
            this.requiredSkills = requiredSkills;
        }
    }
}
