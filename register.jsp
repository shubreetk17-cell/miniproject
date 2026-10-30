
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Registration | SmartFeedback</title>

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
                JOIN SMARTFEEDBACK
            </span>

            <h1>Your feedback.<br>Your future.</h1>

            <p>
                Join our student feedback platform
                to share your academic experiences
                and support continuous improvement.
            </p>

            <div class="auth-feature">
                &#10003; Quick student registration
            </div>

            <div class="auth-feature">
                &#10003; Secure account access
            </div>

            <div class="auth-feature">
                &#10003; Meaningful academic feedback
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
                    GET STARTED
                </span>

                <h2>Create your account</h2>

                <p>
                    Fill in your details to join
                    the SmartFeedback platform.
                </p>

            </div>

            <form action="RegisterServlet" method="post">

                <div class="form-group">

                    <label for="studentName">
                        Full Name
                    </label>

                    <input
                        type="text"
                        id="studentName"
                        name="studentName"
                        class="form-control"
                        placeholder="Enter your full name"
                        autocomplete="name"
                        required>

                </div>

                <div class="form-group">

                    <label for="email">
                        Email Address
                    </label>

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

                    <label for="password">
                        Create Password
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-control"
                        placeholder="Minimum 8 characters"
                        minlength="8"
                        autocomplete="new-password"
                        required>

                </div>

                <button type="submit"
                        class="btn btn-primary auth-submit">
                    Create Account &rarr;
                </button>

            </form>

            <p class="auth-switch">
                Already have an account?
                <a href="login.jsp">Sign In</a>
            </p>

            <a href="index.html" class="auth-back">
                &larr; Back to Home
            </a>

        </div>

    </section>

</div>

</body>
</html>
