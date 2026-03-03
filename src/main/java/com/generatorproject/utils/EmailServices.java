package com.generatorproject.utils;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.Random;
import java.io.UnsupportedEncodingException; // Thêm thư viện này

public class EmailServices {

    private static final String HOST_NAME = "smtp.gmail.com";
    private static final int TSL_PORT = 587;
    private static final String APP_EMAIL = "huyasus2852@gmail.com";
    private static final String APP_PASSWORD = "fmqj ctiy tthb vgac";

    public static boolean sendWelcomeEmail(String toEmail, String fullName, String rawPassword) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST_NAME);
        props.put("mail.smtp.port", TSL_PORT);
        props.put("mail.smtp.ssl.trust", HOST_NAME);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(APP_EMAIL, APP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);

            message.setFrom(new InternetAddress(APP_EMAIL, "Generator Project Admin", "UTF-8"));

            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

            message.setSubject("Thông báo tài khoản mới - Generator Project", "UTF-8");

            String htmlContent = "<!DOCTYPE html>"
                    + "<html><head><meta charset='UTF-8'></head><body>" // <--- QUAN TRỌNG
                    + "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd;'>"
                    + "<h2 style='color: #28a745;'>Xin chào " + fullName + "!</h2>"
                    + "<p>Tài khoản của bạn tại hệ thống <b>Generator CMS</b> đã được khởi tạo thành công.</p>"
                    + "<p>Dưới đây là thông tin đăng nhập của bạn:</p>"
                    + "<ul>"
                    + "<li><b>Email:</b> " + toEmail + "</li>"
                    + "<li><b>Mật khẩu:</b> <span style='font-size: 18px; color: #d9534f; font-weight: bold;'>"
                    + rawPassword + "</span></li>"
                    + "</ul>"
                    + "<p>Vui lòng đăng nhập và đổi mật khẩu ngay trong lần đầu tiên.</p>"
                    + "<p>Trân trọng,<br>Admin Team</p>"
                    + "</div>"
                    + "</body></html>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("Email sent successfully to " + toEmail);
            return true;

        } catch (MessagingException | UnsupportedEncodingException e) {
            e.printStackTrace();
            System.out.println("Gửi email thất bại: " + e.getMessage());
            return false;
        }
    }

    public static String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}