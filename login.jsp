
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Login | SmartFeedback</title>

    <link rel="stylesheet" href="style.css">
</head>

<body class="auth-body">

<div class="auth-layout">

    <section class="auth-brand">

        <a href="index.html" class="auth-logo">
            <span class="auth-logo-icon">&#10022;</span>
            SmartFeedback
        </a>

        <div class="auth-brand-content">
            <span class="auth-eyebrow">
                SMART STUDENT FEEDBACK SYSTEM
            </span>

            <h1>Every opinion<br>makes an impact.</h1>

            <p>
                A secure platform where students can
                share meaningful feedback and contribute
                to better learning experiences.
            </p>

            <div class="auth-feature">
                &#10003; Secure student authentication
            </div>

            <div class="auth-feature">
                &#10003; Teacher and subject feedback
            </div>

            <div class="auth-feature">
                &#10003; Data-driven academic insights
            </div>
        </div>

        <p class="auth-brand-footer">
            Smart Feedback and Sentiment Analysis Portal
        </p>

    </section>

    <section class="auth-panel">

        <div class="auth-card">

            <div class="auth-heading">
                <span class="auth-kicker">
                    WELCOME BACK
                </span>

                <h2>Sign in to your account</h2>

                <p>
                    Enter your credentials to continue
                    to your feedback portal.
                </p>
            </div>

            <form action="LoginServlet" method="post">

                <div class="form-group">
                    <label for="email">Email Address</label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-control"
                        placeholder="student@example.com"
                        autocomplete="email"
                        required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-control"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>
                </div>

                <button type="submit"
                        class="btn btn-primary auth-submit">
                    Sign In &rarr;
                </button>

            </form>

            <p class="auth-switch">
                Don't have an account?
                <a href="register.jsp">Create account</a>
            </p>

            <a href="index.html" class="auth-back">
                &larr; Back to Home
            </a>

        </div>

    </section>

</div>

</body>
</html>
