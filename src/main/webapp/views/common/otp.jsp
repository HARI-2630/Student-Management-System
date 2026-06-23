<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - OTP Verification</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #090b11;
            color: #f8fafc;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .otp-container {
            width: 100%;
            max-width: 450px;
            padding: 15px;
        }
        .glass-card {
            background: rgba(17, 20, 34, 0.65);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 24px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
            padding: 40px;
        }
        .logo-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 20px rgba(99, 102, 241, 0.4);
            margin: 0 auto 16px auto;
            font-size: 1.5rem;
            color: #fff;
        }
        .logo-text {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            font-size: 1.75rem;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0;
            text-align: center;
        }
        .form-control-otp {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            color: #f8fafc;
            padding: 12px 16px;
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: 8px;
            text-align: center;
            transition: all 0.2s;
        }
        .form-control-otp:focus {
            background-color: rgba(255, 255, 255, 0.02);
            border-color: #6366f1;
            box-shadow: 0 0 10px rgba(99, 102, 241, 0.2);
            color: #f8fafc;
        }
        .form-control-otp::placeholder {
            color: #475569;
            letter-spacing: 0px;
            font-weight: 400;
            font-size: 1rem;
        }
        .btn-submit {
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            border: none;
            border-radius: 12px;
            font-weight: 600;
            padding: 12px;
            transition: all 0.2s;
        }
        .btn-submit:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        .btn-resend {
            color: #a855f7;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-resend:hover {
            color: #c084fc;
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="otp-container">
        <div class="glass-card">
            
            <div class="logo-icon">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <h1 class="logo-text mb-4">AuraSMS</h1>
            
            <h4 class="text-center fw-semibold mb-2" style="font-family: 'Outfit';">Security Verification</h4>
            <p class="text-center text-muted small mb-4">
                We sent a 6-digit verification code to your email <strong class="text-light">${pendingOtpUser.email}</strong>.
            </p>

            <!-- Alerts -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center gap-2 py-2" role="alert" style="border-radius: 10px; font-size: 0.85rem;">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <div>${error}</div>
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success d-flex align-items-center gap-2 py-2" role="alert" style="border-radius: 10px; font-size: 0.85rem;">
                    <i class="bi bi-check-circle-fill"></i>
                    <div>${success}</div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login-otp" method="POST" class="needs-validation" novalidate>
                <div class="mb-4">
                    <label for="otpCode" class="form-label text-muted small fw-semibold d-block text-center mb-3">Enter 6-Digit Code</label>
                    <input type="text" class="form-control form-control-otp" id="otpCode" name="otpCode" 
                           placeholder="000000" maxlength="6" pattern="\d{6}" autocomplete="off" required>
                    <div class="invalid-feedback text-center mt-2">Please enter a valid 6-digit numeric code.</div>
                </div>

                <button type="submit" class="btn btn-primary btn-submit w-100 mb-3">
                    Verify & Continue
                </button>
            </form>

            <div class="text-center mt-3 small">
                <span class="text-muted">Didn't receive the code?</span>
                <a href="${pageContext.request.contextPath}/login-otp?action=resend" class="btn-resend ms-1">
                    Resend Code
                </a>
            </div>

            <div class="text-center mt-4 pt-2 border-top border-secondary">
                <a href="${pageContext.request.contextPath}/login" class="text-muted small text-decoration-none">
                    <i class="bi bi-arrow-left"></i> Back to Sign In
                </a>
            </div>

        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form Validation Bootstrap Helper
        (() => {
            'use strict'
            const forms = document.querySelectorAll('.needs-validation')
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html>
