package com.generatorproject.services;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

public class OcrService {
    public String readText(File file) {
        if (file == null || !file.exists()) {
            return "";
        }
        String lower = file.getName().toLowerCase();
        try {
            if (lower.endsWith(".pdf")) {
                try (PDDocument document = PDDocument.load(file)) {
                    return new PDFTextStripper().getText(document);
                }
            }
            if (lower.endsWith(".txt") || lower.endsWith(".csv")) {
                return new String(Files.readAllBytes(file.toPath()), StandardCharsets.UTF_8);
            }
        } catch (Exception ignored) {
        }
        return file.getName();
    }
}
