package com.generatorproject.services;

import com.generatorproject.dao.TokenDao;
import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Users;

import java.util.List;
import java.util.Map;

public class UserServices implements IUserServices {
    private static final String ROLE_ADMIN = "ADMIN";
    private static final String ROLE_SUPER_ADMIN = "SUPER_ADMIN";

    private final UserDao userDao;
    private final TokenDao tokenDao;
    private final RoleServices roleServices;

    public UserServices() {
        this.userDao = new UserDao();
        this.tokenDao = new TokenDao();
        this.roleServices = new RoleServices();
    }
    @Override
    public void updateProfile(Users user) throws Exception {
        userDao.updateProfile(user);
    }
    @Override
    public List<Users> getAllUsers() {
        return userDao.getAllUsers();
    }

    @Override
    public void createUser(Users user) throws Exception {
        userDao.createUser(user);
    }

    @Override
    public Users findUserById(int id) {
        return userDao.findUserById(id);
    }

    @Override
    public void updateUser(Users user) throws Exception {
        userDao.updateUser(user);
    }

    @Override
    public Users findByEmailAndPassword(String email, String password) {
        return userDao.checkLogin(email, password);
    }

    @Override
    public String generatePasswordResetToken(String email) {
        Users user = userDao.findByEmail(email);
        if (user != null) {
            String token = java.util.UUID.randomUUID().toString();
            tokenDao.saveToken(user.getId(), token); // Lưu vào DB thông qua TokenDao
            return token;
        }
        return null;
    }

    @Override
    public Users findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public Integer getUserIdByValidToken(String token) {
        return tokenDao.getUserIdByValidToken(token);
    }

    @Override
    public void markTokenAsUsed(String token) {
        tokenDao.markAsUsed(token);
    }

    @Override
    public boolean changeStatus(int userId, int newStatus) {
        return userDao.changeStatus(userId, newStatus);
    }

    @Override
    public List<Map<String, Object>> getPendingRequests() {
        return tokenDao.getPendingRequests();
    }

    @Override
    public void activateToken(String token) {
        tokenDao.activateToken(token);
    }

    @Override
    public void deleteToken(String token) {
        tokenDao.deleteRequest(token);
    }

    public void deleteUser(int targetUserId, Users actor) throws Exception {
        if (actor == null) {
            throw new Exception("Không xác định được người thực hiện thao tác.");
        }

        if (actor.getId() == targetUserId) {
            throw new Exception("Không thể tự xóa chính mình.");
        }

        Users target = userDao.findUserById(targetUserId);
        if (target == null) {
            throw new Exception("User không tồn tại.");
        }

        boolean actorIsSuperAdmin = isSuperAdminRole(actor.getRoleId());
        boolean actorIsAdmin = isAdminRole(actor.getRoleId());
        boolean targetIsAdmin = isAdminRole(target.getRoleId());

        if (targetIsAdmin && !actorIsSuperAdmin) {
            throw new Exception("Chỉ SUPER_ADMIN mới được xóa tài khoản ADMIN.");
        }

        if (!actorIsAdmin && !actorIsSuperAdmin) {
            throw new Exception("Bạn không có quyền xóa người dùng.");
        }

        boolean hasContracts = userDao.hasContracts(targetUserId);
        boolean hasProducts  = userDao.hasProducts(targetUserId);
        boolean isCustomer = target.getRoleId() == 5;

        if (isCustomer) {
            disableCustomerAccess(targetUserId, hasContracts || hasProducts);
            return;
        }

        if (!hasContracts && !hasProducts) {
            userDao.deleteUser(targetUserId);
        } else {
            userDao.anonymizeAndDeactivate(targetUserId);
        }
    }

    @Override
    public void disableCustomerAccess(int userId, boolean anonymize) {
        userDao.changeStatus(userId, 0);
        tokenDao.revokeTokensByUserId(userId);
        if (anonymize) {
            userDao.anonymizePii(userId);
        }
    }


    @Override
    public int countUsersByFilter(String keyword, Integer roleId, Integer status) {
        return userDao.countUsersByFilter(keyword, roleId, status);
    }

    @Override
    public List<Users> getUsersByFilter(String keyword, Integer roleId, Integer status, int page, int pageSize) {
        return userDao.getUsersByFilter(keyword, roleId, status, page, pageSize);
    }

    @Override
    public List<Users> findUserByRoleId(int id) {
        return userDao.findUserByRoleId(id);
    }

    @Override
    public List<Users> getUsersByRole(int roleId) {
        return userDao.findUserByRoleId(roleId);
    }

    @Override
    public int countCustomerByFilter(String keyword) {
        return userDao.countCustomerByFilter(keyword);
    }

    @Override
    public List<Users> getCustomerByFilter(String keyword, int page, int pageSize) {
        return userDao.getCustomerByFilter(keyword, page, pageSize);
    }

    @Override
    public String getRoleName(int roleId) {
        if (roleId <= 0) {
            return "";
        }

        com.generatorproject.model.Role role = roleServices.getRoleById(roleId);
        return role != null && role.getName() != null ? role.getName().trim() : "";
    }

    @Override
    public boolean isAdminRole(int roleId) {
        return ROLE_ADMIN.equalsIgnoreCase(getRoleName(roleId));
    }

    @Override
    public boolean isSuperAdminRole(int roleId) {
        return ROLE_SUPER_ADMIN.equalsIgnoreCase(getRoleName(roleId));
    }

}
