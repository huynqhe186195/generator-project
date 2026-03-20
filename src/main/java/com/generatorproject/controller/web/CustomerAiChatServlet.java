package com.generatorproject.controller.web;

import com.generatorproject.ai.orchestrator.ChatRequest;
import com.generatorproject.ai.orchestrator.ChatResponse;
import com.generatorproject.ai.orchestrator.CmsAiOrchestratorService;
import com.generatorproject.model.Users;
import com.generatorproject.model.ai.CustomerAiResponse;
import com.generatorproject.model.ai.CustomerAiToolCall;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = { "/customer/ai-chat" })
public class CustomerAiChatServlet extends HttpServlet {
    private final Gson gson = new Gson();
    private final CmsAiOrchestratorService orchestratorService = new CmsAiOrchestratorService();

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
            ChatResponse orchestrated = orchestratorService.handle(new ChatRequest((long) user.getId(), user.getRoleId(), message, req.getContextPath()));
            response.setSuccess(orchestrated.isSuccess());
            response.setReply(orchestrated.getReply());
            response.setActionType(orchestrated.getActionType());
            response.setRedirectUrl(orchestrated.getRedirectUrl());
            response.setResults(orchestrated.getResults());
            response.setCitations(orchestrated.getCitations());
            response.setSourcesUsed(orchestrated.getSourcesUsed());
            response.setSkillsCalled(orchestrated.getSkillsCalled());
            response.setActions(orchestrated.getActions());
            resp.getWriter().write(gson.toJson(response));
        } catch (Exception ex) {
            response.setSuccess(false);
            response.setReply("Xin lỗi, tôi chưa xử lý được yêu cầu của bạn. Vui lòng thử lại sau.");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(gson.toJson(response));
        }
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
