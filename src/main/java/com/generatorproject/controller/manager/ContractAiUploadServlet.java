package com.generatorproject.controller.manager;

import com.generatorproject.dao.ContractEventDAO;
import com.generatorproject.dao.DbContext;
import com.generatorproject.model.Users;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet("/manager/contracts/ai/upload")
@MultipartConfig
public class ContractAiUploadServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long contractId = Long.parseLong(req.getParameter("contractId"));
        Part file = req.getPart("sourceFile");
        if (file == null || file.getSize() == 0) {
            resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&msg=no_file");
            return;
        }

        String uploadRoot = req.getServletContext().getRealPath("/uploads/contract-ai");
        Files.createDirectories(Paths.get(uploadRoot));
        String fileName = UUID.randomUUID() + "_" + Paths.get(file.getSubmittedFileName()).getFileName();
        File target = new File(uploadRoot, fileName);
        file.write(target.getAbsolutePath());

        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        Map<String, Object> meta = new HashMap<>();
        meta.put("source_file_path", target.getAbsolutePath());
        new ContractEventDAO().insertEvent(contractId, "AI_UPLOAD", "AI_FILE_UPLOADED", null, null,
                "Upload source file for AI extraction", manager == null ? null : (long) manager.getId(),
                null, null, new Gson().toJson(meta));

        req.getSession().setAttribute("contractAiSourceFilePath_" + contractId, target.getAbsolutePath());
        resp.sendRedirect(req.getContextPath() + "/manager/contracts/draft?id=" + contractId + "&msg=file_uploaded");
    }
}
