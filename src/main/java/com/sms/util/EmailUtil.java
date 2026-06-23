package com.sms.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.util.Properties;

/**
 * Utility class to dispatch verification OTP emails.
 * Uses Tomcat JNDI Session resource for secure credential storage.
 */
public class EmailUtil {
    private static Session mailSession;

    static {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:comp/env");
            mailSession = (Session) envContext.lookup("mail/Session");
        } catch (NamingException e) {
            System.err.println("WARNING: JNDI Mail Session resource 'mail/Session' not found. Will fall back to default properties.");
        }
    }

    /**
     * Sends the OTP code asynchronously to prevent blocking the HTTP login thread.
     */
    public static void sendOtpEmailAsync(String recipientEmail, String otp) {
        new Thread(() -> sendOtpEmail(recipientEmail, otp)).start();
    }

    /**
     * Sends the OTP code synchronously.
     */
    public static void sendOtpEmail(String recipientEmail, String otp) {
        System.out.println("=== Dispatched OTP to " + recipientEmail + " ===");
        
        try {
            Session session = mailSession;
            if (session == null) {
                // Set default fallback properties (uses local/mock setup)
                Properties props = new Properties();
                props.put("mail.smtp.host", "localhost");
                props.put("mail.smtp.port", "25");
                session = Session.getInstance(props);
            }

            MimeMessage message = new MimeMessage(session);
            
            // Set From address
            String from = session.getProperty("mail.from");
            if (from == null) {
                // Fallback to configured username if using authenticator
                from = session.getProperty("mail.smtp.username");
                if (from == null || from.isEmpty() || "aura.sms.dev@gmail.com".equals(from)) {
                    from = "no-reply@aurasms.com";
                }
            }
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            message.setSubject("AuraSMS - Login Verification OTP Code");
            
            // HTML Email content
            String emailContent = 
                "<div style=\"font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 500px; margin: auto; padding: 20px; border: 1px solid #e2e8f0; border-radius: 12px; background-color: #ffffff; color: #1e293b;\">" +
                "  <div style=\"text-align: center; margin-bottom: 20px;\">" +
                "    <h2 style=\"color: #6366f1; font-weight: 700; margin: 0;\">AuraSMS Verification</h2>" +
                "  </div>" +
                "  <p>Hello,</p>" +
                "  <p>To complete your sign-in, please enter the following One-Time Password (OTP) verification code on the login page:</p>" +
                "  <div style=\"text-align: center; margin: 30px 0;\">" +
                "    <span style=\"font-size: 32px; font-weight: 700; letter-spacing: 5px; color: #4f46e5; background-color: #f5f3ff; padding: 12px 24px; border-radius: 8px; border: 1px dashed #c7d2fe;\">" + otp + "</span>" +
                "  </div>" +
                "  <p style=\"font-size: 13px; color: #64748b;\">This code is valid for <strong>5 minutes</strong>. If you did not request this login attempt, please secure your account immediately.</p>" +
                "  <hr style=\"border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;\" />" +
                "  <p style=\"font-size: 11px; text-align: center; color: #94a3b8;\">AuraSMS Portfolio Project &bull; Standard SDE Verification System</p>" +
                "</div>";

            message.setContent(emailContent, "text/html; charset=utf-8");

            // Attempt to send email
            Transport.send(message);
            System.out.println("SUCCESS: OTP Email sent successfully to: " + recipientEmail);

        } catch (Exception e) {
            System.err.println("ERROR: Failed to send OTP email to " + recipientEmail + " via SMTP.");
            System.err.println("Error details: " + e.getMessage());
            
            // Premium Fallback: Print OTP to logs clearly so developers don't get blocked
            System.out.println("\n========================================================");
            System.out.println("[FALLBACK OTP LOGGER]");
            System.out.println("OTP CODE FOR: " + recipientEmail);
            System.out.println("CODE IS: " + otp);
            System.out.println("========================================================\n");
        }
    }
}
