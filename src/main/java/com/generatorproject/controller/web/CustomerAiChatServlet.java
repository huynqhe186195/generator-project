package com.generatorproject.controller.web;

import com.generatorproject.model.Users;
import com.generatorproject.model.ai.CustomerAiResponse;
import com.generatorproject.model.ai.CustomerAiToolCall;
import com.generatorproject.model.ai.DeviceSearchResultDto;
import com.generatorproject.services.CustomerAiToolRouterService;
import com.generatorproject.services.CustomerAiToolService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(urlPatterns = { "/customer/ai-chat" })
public class CustomerAiChatServlet extends HttpServlet {
    private final Gson gson = new Gson();
    private final CustomerAiToolRouterService routerService = new CustomerAiToolRouterService();
    private final CustomerAiToolService toolService = new CustomerAiToolService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        CustomerAiResponse response = new CustomerAiResponse();

        try {
            Users user = (Users) req.getSession().getAttribute("USERMODEL");
            if (user == null || user.getRoleId() != 5) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setSuccess(false);
                response.setReply("Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
                resp.getWriter().write(gson.toJson(response));
                return;
            }

            String message = readMessage(req);
            CustomerAiToolCall toolCall = routerService.route(message);
            buildResponse(req, response, user, toolCall);
            resp.getWriter().write(gson.toJson(response));
        } catch (Exception ex) {
            response.setSuccess(false);
            response.setReply("Xin lỗi, tôi chưa xử lý được yêu cầu của bạn. Vui lòng thử lại sau.");
            response.setResults(Collections.emptyList());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(gson.toJson(response));
        }
    }

    private void buildResponse(HttpServletRequest req, CustomerAiResponse response, Users user, CustomerAiToolCall toolCall) {
        if (toolCall == null || toolCall.getTool() == null || "none".equals(toolCall.getTool())) {
            response.setReply(toolCall == null
                    ? "Xin chào, tôi có thể giúp bạn tìm máy sở hữu có serial hoặc mẫu máy public không có serial.": toolCall.getArg("reply"));
            response.setActionType(CustomerAiResponse.ACTION_NONE);
            return;
        }

        if ("searchOwnedDevices".equals(toolCall.getTool())) {
            List<DeviceSearchResultDto> results = toolService.searchOwnedDevices(user.getId(), toolCall.getArg("keyword"), req.getContextPath());
            response.setResults(results);
            if (results.isEmpty()) {
                response.setReply("Tôi chưa tìm thấy thiết bị sở hữu phù hợp trong danh sách máy của bạn. Bạn có thể thử lại bằng serial, vị trí, trạng thái, tên model hoặc yêu cầu liệt kê tất cả máy bạn đang sở hữu.");
                response.setActionType(CustomerAiResponse.ACTION_NONE);
                return;
            }
            if (results.size() == 1 && !toolService.shouldPreferShowingResults(toolCall.getArg("keyword"))) {
                DeviceSearchResultDto item = results.get(0);
                response.setReply("Tôi đã tìm thấy đúng 1 thiết bị sở hữu của bạn và sẽ mở trang chi tiết model liên quan.");
                response.setActionType(CustomerAiResponse.ACTION_REDIRECT);
                response.setRedirectUrl(item.getDetailUrl());
                return;
            }
            response.setReply("Tôi tìm thấy " + results.size() + " thiết bị sở hữu của bạn. Bạn hãy chọn đúng máy theo serial, vị trí hoặc trạng thái.");
            response.setActionType(CustomerAiResponse.ACTION_SHOW_RESULTS);
            return;
        }

        if ("searchPublicDevices".equals(toolCall.getTool())) {
            List<DeviceSearchResultDto> results = toolService.searchPublicDevices(toolCall.getArg("keyword"), req.getContextPath());
            response.setResults(results);
            if (results.isEmpty()) {
                response.setReply("Tôi chưa tìm thấy tài liệu public phù hợp. Bạn có thể thử lại bằng model, thương hiệu, thông số, nhiên liệu, xuất xứ hoặc yêu cầu liệt kê tài liệu public.");
                response.setActionType(CustomerAiResponse.ACTION_NONE);
                return;
            }
            if (results.size() == 1 && !toolService.shouldPreferShowingResults(toolCall.getArg("keyword"))) {
                DeviceSearchResultDto item = results.get(0);
                response.setReply("Tôi đã tìm thấy đúng 1 mẫu máy public và sẽ mở trang tài liệu / thông tin chi tiết cho bạn.");
                response.setActionType(CustomerAiResponse.ACTION_REDIRECT);
                response.setRedirectUrl(item.getDetailUrl());
                return;
            }
            response.setReply("Tôi tìm thấy " + results.size() + " mẫu máy public. Bạn chọn giúp tôi đúng model tài liệu bạn muốn xem.");
            response.setActionType(CustomerAiResponse.ACTION_SHOW_RESULTS);
            return;
        }

        response.setReply("Hiện tôi hỗ trợ 2 loại device: thiết bị sở hữu có serial và tài liệu public theo model.");
        response.setActionType(CustomerAiResponse.ACTION_NONE);
    }

    private String readMessage(HttpServletRequest req) throws IOException {
        String message = req.getParameter("message");
        if (message != null) {
            return message;
        }
        CustomerAiToolCall body = gson.fromJson(req.getReader(), CustomerAiToolCall.class);
        return body == null ? null : body.getArg("message");
    }
}