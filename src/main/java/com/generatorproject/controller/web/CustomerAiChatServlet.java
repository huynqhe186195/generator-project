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
            response.setResults(Collections.<DeviceSearchResultDto>emptyList());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(gson.toJson(response));
        }
    }

    private void buildResponse(HttpServletRequest req, CustomerAiResponse response, Users user, CustomerAiToolCall toolCall) {
        if (toolCall == null || toolCall.getTool() == null || "none".equals(toolCall.getTool())) {
            response.setReply(toolCall == null ? "Xin chào, tôi có thể giúp bạn tìm thiết bị của bạn." : toolCall.getArg("reply"));
            response.setActionType(CustomerAiResponse.ACTION_NONE);
            return;
        }

        if ("searchDevices".equals(toolCall.getTool())) {
            List<DeviceSearchResultDto> results = toolService.searchDevices(user.getId(), toolCall.getArg("keyword"), req.getContextPath());
            response.setResults(results);
            if (results.isEmpty()) {
                response.setReply("Tôi chưa tìm thấy thiết bị phù hợp trong danh sách máy của bạn. Hãy thử bằng model hoặc serial cụ thể hơn.");
                response.setActionType(CustomerAiResponse.ACTION_NONE);
                return;
            }
            if (results.size() == 1) {
                DeviceSearchResultDto item = results.get(0);
                response.setReply("Tôi đã tìm thấy đúng 1 thiết bị phù hợp và sẽ mở trang chi tiết mẫu máy cho bạn.");
                response.setActionType(CustomerAiResponse.ACTION_REDIRECT);
                response.setRedirectUrl(item.getDetailUrl());
                return;
            }
            response.setReply("Tôi tìm thấy nhiều thiết bị phù hợp. Bạn chọn giúp tôi đúng máy bạn muốn xem.");
            response.setActionType(CustomerAiResponse.ACTION_SHOW_RESULTS);
            return;
        }

        response.setReply("Hiện tôi mới hỗ trợ tìm thiết bị của bạn theo model hoặc serial.");
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
