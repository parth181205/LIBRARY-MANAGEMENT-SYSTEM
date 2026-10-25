package com.amity.library.controller;

import com.amity.library.service.AuthService;
import com.amity.library.service.TurnstileService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();
    private final TurnstileService turnstileService = new TurnstileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String enrollmentNo = request.getParameter("enrollmentNo");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String department = request.getParameter("department");
        String course = request.getParameter("course");
        String academicYear = request.getParameter("academicYear");
        String phone = request.getParameter("phone");
        String turnstileToken = request.getParameter("cf-turnstile-response");
        String clientIp = request.getRemoteAddr();

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            forwardBack(request, response, enrollmentNo, fullName, email, department, course, academicYear, phone);
            return;
        }

        // Verify turnstile token
        TurnstileService.VerificationResult turnstileResult = turnstileService.verify(turnstileToken, clientIp);
        if (!turnstileResult.isValid()) {
            request.setAttribute("errorMessage", turnstileResult.getErrorMessage());
            forwardBack(request, response, enrollmentNo, fullName, email, department, course, academicYear, phone);
            return;
        }

        AuthService.RegistrationResult result = authService.registerStudent(
                enrollmentNo, fullName, email, password, department, course, academicYear, phone, clientIp
        );

        if (result.isSuccess()) {
            response.sendRedirect(request.getContextPath() + "/login?registered=success");
        } else {
            request.setAttribute("errorMessage", result.getMessage());
            forwardBack(request, response, enrollmentNo, fullName, email, department, course, academicYear, phone);
        }
    }

    private void forwardBack(HttpServletRequest req, HttpServletResponse resp,
                             String enrollmentNo, String fullName, String email,
                             String department, String course, String academicYear, String phone)
            throws ServletException, IOException {
        req.setAttribute("enrollmentNo", enrollmentNo);
        req.setAttribute("fullName", fullName);
        req.setAttribute("email", email);
        req.setAttribute("department", department);
        req.setAttribute("course", course);
        req.setAttribute("academicYear", academicYear);
        req.setAttribute("phone", phone);
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }
}
