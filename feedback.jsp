
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    jakarta.servlet.http.HttpSession loginSession =
            request.getSession(false);

    if (loginSession == null ||
        !(loginSession.getAttribute("studentId") instanceof Integer)) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp");
        return;
    }

    String studentName =
            (String) loginSession.getAttribute("studentName");

    if (studentName == null || studentName.isBlank()) {
        studentName = "Student";
    }

    String safeStudentName = studentName
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Feedback Dashboard | SmartFeedback</title>

    <link rel="stylesheet" href="style.css">
</head>

<div style="text-align:center; margin:25px;">
    <a href="${pageContext.request.contextPath}/analytics.jsp"
       style="
           display:inline-block;
           background:#087F73;
           color:white;
           padding:13px 25px;
           border-radius:10px;
           text-decoration:none;
           font-weight:bold;
           font-family:Arial,sans-serif;
       ">
        View Feedback Analytics
    </a>
</div>


<body>

<div class="dashboard">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="logo">
            <div class="logo-icon">&#10022;</div>
            <span>SmartFeedback</span>
        </div>

        <div class="nav-label">STUDENT PORTAL</div>

        <nav>
            <a href="feedback.jsp" class="nav-link active">
                <span class="nav-icon">&#9638;</span>
                My Dashboard
            </a>

            <a href="#feedback-form" class="nav-link">
                <span class="nav-icon">&#9998;</span>
                Give Feedback
            </a>

            <a href="index.html" class="nav-link">
                <span class="nav-icon">&#8962;</span>
                Home
            </a>
        </nav>

        <div class="sidebar-bottom">
            <form action="LogoutServlet" method="post">
                <button type="submit"
                        class="btn btn-logout">
                    Logout
                </button>
            </form>
        </div>

    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <header class="topbar">

            <div>
                <h2 class="page-title">Student Dashboard</h2>
                <p class="dashboard-subtitle">
                    Manage your academic feedback
                </p>
            </div>

            <div class="topbar-right">
                <div class="avatar">SF</div>
            </div>

        </header>

        <!-- WELCOME BANNER -->
        <section class="hero">

            <div class="hero-tag">
                WELCOME TO SMARTFEEDBACK
            </div>

            <h1>
                Hello, <%=safeStudentName%>!
            </h1>

            <p>
                Your opinion matters. Share your
                experience with teachers and subjects
                to help improve the learning environment.
            </p>

            <a href="#feedback-form" class="btn">
                Submit Feedback &rarr;
            </a>

        </section>

        <!-- FEATURE CARDS -->
        <h2 class="section-title">
            Your Feedback Portal
        </h2>

        <section class="cards">

            <article class="card">

                <div class="card-icon">&#9998;</div>

                <h3>Teacher Evaluation</h3>

                <p>
                    Share feedback about your
                    teachers and teaching experience.
                </p>

            </article>

            <article class="card">

                <div class="card-icon">&#9733;</div>

                <h3>Academic Ratings</h3>

                <p>
                    Rate your learning experience
                    on a scale from 1 to 5.
                </p>

            </article>

            <article class="card">

                <div class="card-icon">&#10003;</div>

                <h3>Secure Submission</h3>

                <p>
                    Your feedback is linked to
                    your authenticated account.
                </p>

            </article>

        </section>

        <!-- FEEDBACK FORM -->
        <section id="feedback-form"
                 class="form-card feedback-card">

            <h2 class="section-title">
                Submit Your Feedback
            </h2>

            <p class="feedback-intro">
                Select your teacher and subject,
                provide a rating and share your thoughts.
            </p>

            <form action="FeedbackServlet" method="post">

                <div class="form-group">
                    <label for="teacher">
                        Select Teacher
                    </label>

                    <select name="teacherId"
                            id="teacher"
                            class="form-control"
                            required>

                        <option value="">
                            -- Select Teacher --
                        </option>

                    </select>
                </div>

                <div class="form-group">
                    <label for="subject">
                        Select Subject
                    </label>

                    <select name="subjectId"
                            id="subject"
                            class="form-control"
                            required>

                        <option value="">
                            -- Select Subject --
                        </option>

                    </select>
                </div>

                <div class="form-group">
                    <label for="rating">
                        Rate Your Experience
                    </label>

                    <select name="rating"
                            id="rating"
                            class="form-control"
                            required>

                        <option value="">
                            -- Choose Rating --
                        </option>

                        <option value="5">5 - Excellent</option>
                        <option value="4">4 - Good</option>
                        <option value="3">3 - Average</option>
                        <option value="2">2 - Poor</option>
                        <option value="1">1 - Very Poor</option>

                    </select>
                </div>

                <div class="form-group">
                    <label for="comments">
                        Your Feedback
                    </label>

                    <textarea name="comments"
                              id="comments"
                              class="form-control"
                              rows="5"
                              maxlength="5000"
                              placeholder="Share your experience..."
                              required></textarea>
                </div>

                <button type="submit"
                        class="btn btn-primary">
                    Submit Feedback &rarr;
                </button>

            </form>

        </section>

        <footer class="footer">
            &copy; 2026 SmartFeedback |
            Student Feedback Dashboard
        </footer>

    </main>

</div>

<!-- DYNAMIC TEACHER-SUBJECT DROPDOWN -->

<script>
    const assignments = [];

    <%
        String url =
                "jdbc:mysql://localhost:3306/smart_feedback";

        String user = "root";

        String password =
                System.getenv("SMART_FEEDBACK_DB_PASSWORD");

        String sql =
                "SELECT t.teacher_id, t.teacher_name, "
                + "s.subject_id, s.subject_name "
                + "FROM teacher_subject ts "
                + "JOIN teachers t "
                + "ON ts.teacher_id = t.teacher_id "
                + "JOIN subjects s "
                + "ON ts.subject_id = s.subject_id "
                + "ORDER BY t.teacher_name, s.subject_name";

        try {

            if (password == null || password.isEmpty()) {
                throw new Exception(
                        "Database password not configured");
            }

            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con =
                    DriverManager.getConnection(
                            url, user, password);

                 PreparedStatement ps =
                    con.prepareStatement(sql);

                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    String teacherName =
                            rs.getString("teacher_name")
                            .replace("\\", "\\\\")
                            .replace("'", "\\'")
                            .replace("\r", "\\r")
                            .replace("\n", "\\n")
                            .replace("<", "\\u003C")
                            .replace(">", "\\u003E")
                            .replace("&", "\\u0026");

                    String subjectName =
                            rs.getString("subject_name")
                            .replace("\\", "\\\\")
                            .replace("'", "\\'")
                            .replace("\r", "\\r")
                            .replace("\n", "\\n")
                            .replace("<", "\\u003C")
                            .replace(">", "\\u003E")
                            .replace("&", "\\u0026");
    %>

    assignments.push({
        teacherId: <%=rs.getInt("teacher_id")%>,
        teacherName: '<%=teacherName%>',
        subjectId: <%=rs.getInt("subject_id")%>,
        subjectName: '<%=subjectName%>'
    });

    <%
                }
            }

        } catch (Exception e) {

            application.log(
                    "Error loading teacher subjects", e);
    %>

    alert("Unable to load teachers and subjects.");

    <%
        }
    %>

    const teacherSelect =
            document.getElementById("teacher");

    const subjectSelect =
            document.getElementById("subject");

    const uniqueTeachers = new Map();

    assignments.forEach(item => {
        uniqueTeachers.set(
                item.teacherId,
                item.teacherName);
    });

    uniqueTeachers.forEach((name, id) => {

        const option =
                document.createElement("option");

        option.value = id;
        option.textContent = name;

        teacherSelect.appendChild(option);
    });

    teacherSelect.addEventListener(
            "change", function() {

        subjectSelect.innerHTML =
            '<option value="">-- Select Subject --</option>';

        const selectedTeacher =
                Number(this.value);

        assignments
            .filter(item =>
                item.teacherId === selectedTeacher)
            .forEach(item => {

                const option =
                        document.createElement("option");

                option.value = item.subjectId;
                option.textContent = item.subjectName;

                subjectSelect.appendChild(option);
            });
    });
</script>

</body>
</html>
