
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%!
    String escapeJson(String s) {
        if (s == null) return "";

        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("<", "\\u003C")
                .replace(">", "\\u003E")
                .replace("&", "\\u0026");
    }

    String findSentiment(String comment) {

        if (comment == null || comment.trim().isEmpty()) {
            return "Neutral";
        }

        String[] positiveWords = {
            "good", "excellent", "great", "helpful",
            "clear", "clearly", "best", "amazing",
            "friendly", "interesting", "supportive",
            "easy", "understandable", "perfect",
            "patient", "nice", "effective"
        };

        String[] negativeWords = {
            "bad", "poor", "boring", "confusing",
            "difficult", "worst", "rude", "unclear",
            "slow", "unhelpful", "terrible",
            "disappointing", "hard", "impatient"
        };

        String[] words = comment.toLowerCase(
            java.util.Locale.ROOT
        ).split("[^a-z]+");

        int positive = 0;
        int negative = 0;

        for (String word : words) {

            for (String p : positiveWords) {
                if (word.equals(p)) {
                    positive++;
                }
            }

            for (String n : negativeWords) {
                if (word.equals(n)) {
                    negative++;
                }
            }
        }

        if (positive > negative) return "Positive";
        if (negative > positive) return "Negative";

        return "Neutral";
    }
%>

<%
    // Public analytics: no student login required.
    // Only aggregate statistics are displayed.

    String dbUrl =
        "jdbc:mysql://localhost:3306/smart_feedback";

    String dbUser = "root";

    String dbPassword =
        System.getenv("SMART_FEEDBACK_DB_PASSWORD");

    int totalFeedback = 0;
    int positive = 0;
    int negative = 0;
    int neutral = 0;

    double ratingSum = 0;

    int[] ratingCounts = new int[5];

    Map<String, double[]> teacherStats =
        new LinkedHashMap<String, double[]>();

    Map<String, Integer> subjectCounts =
        new LinkedHashMap<String, Integer>();

    String errorMessage = "";

    try {

        if (dbPassword == null || dbPassword.isEmpty()) {
            throw new Exception(
                "Database password not configured"
            );
        }

        Class.forName("com.mysql.cj.jdbc.Driver");

        String sql =
            "SELECT t.teacher_name, s.subject_name, " +
            "f.rating, f.comments " +
            "FROM feedback f " +
            "JOIN teachers t " +
            "ON f.teacher_id = t.teacher_id " +
            "JOIN subjects s " +
            "ON f.subject_id = s.subject_id";

        try (
            Connection con =
                DriverManager.getConnection(
                    dbUrl, dbUser, dbPassword
                );

            PreparedStatement ps =
                con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                String teacher =
                    rs.getString("teacher_name");

                String subject =
                    rs.getString("subject_name");

                int rating =
                    rs.getInt("rating");

                String comment =
                    rs.getString("comments");

                totalFeedback++;
                ratingSum += rating;

                if (rating >= 1 && rating <= 5) {
                    ratingCounts[rating - 1]++;
                }

                String sentiment =
                    findSentiment(comment);

                if (sentiment.equals("Positive")) {
                    positive++;
                } else if (sentiment.equals("Negative")) {
                    negative++;
                } else {
                    neutral++;
                }

                if (!teacherStats.containsKey(teacher)) {
                    teacherStats.put(
                        teacher,
                        new double[]{0, 0}
                    );
                }

                double[] stats =
                    teacherStats.get(teacher);

                stats[0] += rating;
                stats[1]++;

                subjectCounts.put(
                    subject,
                    subjectCounts.getOrDefault(
                        subject, 0
                    ) + 1
                );
            }
        }

    } catch (Exception e) {
        application.log("Analytics database error", e);
        errorMessage =
            "Unable to load analytics. Please try again.";
    }

    double averageRating =
        totalFeedback == 0
        ? 0
        : ratingSum / totalFeedback;

    StringBuilder teacherLabels =
        new StringBuilder();

    StringBuilder teacherValues =
        new StringBuilder();

    for (Map.Entry<String, double[]> entry :
            teacherStats.entrySet()) {

        if (teacherLabels.length() > 0) {
            teacherLabels.append(",");
            teacherValues.append(",");
        }

        teacherLabels.append("\"")
            .append(escapeJson(entry.getKey()))
            .append("\"");

        double[] stats = entry.getValue();

        double avg = stats[0] / stats[1];

        teacherValues.append(
            String.format(
                java.util.Locale.US,
                "%.2f",
                avg
            )
        );
    }

    StringBuilder subjectLabels =
        new StringBuilder();

    StringBuilder subjectValues =
        new StringBuilder();

    for (Map.Entry<String, Integer> entry :
            subjectCounts.entrySet()) {

        if (subjectLabels.length() > 0) {
            subjectLabels.append(",");
            subjectValues.append(",");
        }

        subjectLabels.append("\"")
            .append(escapeJson(entry.getKey()))
            .append("\"");

        subjectValues.append(entry.getValue());
    }

    // JSON endpoint for automatic chart updates
    if ("1".equals(request.getParameter("data"))) {

        response.setContentType(
            "application/json;charset=UTF-8"
        );

        response.setHeader(
            "Cache-Control",
            "no-store"
        );

        if (!errorMessage.isEmpty()) {

            response.setStatus(500);

            out.print(
                "{\"error\":\"Unable to load analytics\"}"
            );

        } else {

            out.print("{");

            out.print(
                "\"total\":" + totalFeedback + ","
            );

            out.print(
                "\"average\":" +
                String.format(
                    java.util.Locale.US,
                    "%.2f",
                    averageRating
                ) + ","
            );

            out.print(
                "\"positive\":" + positive + ","
            );

            out.print(
                "\"negative\":" + negative + ","
            );

            out.print(
                "\"neutral\":" + neutral + ","
            );

            out.print(
                "\"ratingCounts\":[" +
                ratingCounts[0] + "," +
                ratingCounts[1] + "," +
                ratingCounts[2] + "," +
                ratingCounts[3] + "," +
                ratingCounts[4] + "],"
            );

            out.print(
                "\"teacherLabels\":[" +
                teacherLabels + "],"
            );

            out.print(
                "\"teacherValues\":[" +
                teacherValues + "],"
            );

            out.print(
                "\"subjectLabels\":[" +
                subjectLabels + "],"
            );

            out.print(
                "\"subjectValues\":[" +
                subjectValues + "]"
            );

            out.print("}");
        }

        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Feedback Analytics | SmartFeedback</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #F5F3EA;
    color: #102A33;
}

header {
    background: #102A33;
    color: white;
    padding: 25px;
    text-align: center;
}

header h1 {
    margin: 0 0 10px;
}

header p {
    color: #DCEAE7;
    margin: 0;
}

.container {
    max-width: 1150px;
    margin: 30px auto;
    padding: 15px;
}

.back-btn {
    display: inline-block;
    background: #087F73;
    color: white;
    text-decoration: none;
    padding: 12px 20px;
    border-radius: 10px;
    font-weight: bold;
    margin-bottom: 25px;
}

.back-btn:hover {
    background: #06685F;
}

.stats {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 18px;
}

.stat-card {
    background: white;
    border-radius: 15px;
    padding: 25px 15px;
    text-align: center;
    box-shadow: 0 4px 15px rgba(0,0,0,0.06);
}

.stat-card h2 {
    color: #087F73;
    font-size: 32px;
    margin: 5px 0;
}

.stat-card p {
    color: #64748B;
    font-size: 14px;
}

.graphs {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 22px;
    margin-top: 30px;
}

.graph-card {
    background: white;
    padding: 25px;
    border-radius: 16px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.06);
}

.graph-card h3 {
    text-align: center;
    margin-top: 0;
    margin-bottom: 20px;
}

.chart-box {
    position: relative;
    height: 300px;
}

.status {
    text-align: center;
    color: #64748B;
    margin-top: 25px;
    font-size: 14px;
}

@media (max-width: 850px) {

    .stats {
        grid-template-columns: repeat(2, 1fr);
    }

    .graphs {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 500px) {

    .stats {
        grid-template-columns: 1fr;
    }

    .container {
        padding: 12px;
    }
}

</style>

</head>

<body>

<header>
    <h1>Smart Feedback Analytics Dashboard</h1>
    <p>
        Live Teacher Performance & Sentiment Analysis
    </p>
</header>

<div class="container">

    <a href="<%=request.getContextPath()%>/index.html"
       class="back-btn">
        ← Back to Homepage
    </a>

    <% if (!errorMessage.isEmpty()) { %>

        <p style="color:#dc2626;">
            <%=errorMessage%>
        </p>

    <% } %>

    <div class="stats">

        <div class="stat-card">
            <h2 id="total">
                <%=totalFeedback%>
            </h2>
            <p>Total Feedback</p>
        </div>

        <div class="stat-card">
            <h2 id="average">
                <%=String.format(
                    java.util.Locale.US,
                    "%.2f",
                    averageRating
                )%>
            </h2>
            <p>Average Rating</p>
        </div>

        <div class="stat-card">
            <h2 id="positive">
                <%=positive%>
            </h2>
            <p>Positive Feedback</p>
        </div>

        <div class="stat-card">
            <h2 id="negative">
                <%=negative%>
            </h2>
            <p>Negative Feedback</p>
        </div>

    </div>

    <div class="graphs">

        <div class="graph-card">
            <h3>Sentiment Distribution</h3>
            <div class="chart-box">
                <canvas id="sentimentChart"></canvas>
            </div>
        </div>

        <div class="graph-card">
            <h3>Teacher Average Ratings</h3>
            <div class="chart-box">
                <canvas id="teacherChart"></canvas>
            </div>
        </div>

        <div class="graph-card">
            <h3>Rating Distribution</h3>
            <div class="chart-box">
                <canvas id="ratingChart"></canvas>
            </div>
        </div>

        <div class="graph-card">
            <h3>Subject-wise Feedback</h3>
            <div class="chart-box">
                <canvas id="subjectChart"></canvas>
            </div>
        </div>

    </div>

    <p class="status" id="status">
        Analytics automatically updates every 10 seconds.
    </p>

</div>

<script>

const charts = {};

function drawChart(
    id, type, labels, values, colors, maxY
) {

    if (charts[id]) {
        charts[id].destroy();
    }

    const options = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: type === "pie"
            }
        }
    };

    if (type !== "pie") {
        options.scales = {
            y: {
                beginAtZero: true
            }
        };

        if (maxY) {
            options.scales.y.max = maxY;
        }
    }

    charts[id] = new Chart(
        document.getElementById(id),
        {
            type: type,
            data: {
                labels: labels,
                datasets: [{
                    label: "Feedback Analytics",
                    data: values,
                    backgroundColor: colors,
                    borderWidth: 1
                }]
            },
            options: options
        }
    );
}

async function updateDashboard() {

    try {

        const response = await fetch(
            window.location.pathname + "?data=1",
            {
                cache: "no-store"
            }
        );

        if (!response.ok) {
            throw new Error("Data loading failed");
        }

        const data = await response.json();

        document.getElementById("total").textContent =
            data.total;

        document.getElementById("average").textContent =
            Number(data.average).toFixed(2);

        document.getElementById("positive").textContent =
            data.positive;

        document.getElementById("negative").textContent =
            data.negative;

        drawChart(
            "sentimentChart",
            "pie",
            ["Positive", "Negative", "Neutral"],
            [
                data.positive,
                data.negative,
                data.neutral
            ],
            [
                "#087F73",
                "#EF4444",
                "#94A3B8"
            ]
        );

        drawChart(
            "teacherChart",
            "bar",
            data.teacherLabels,
            data.teacherValues,
            "#087F73",
            5
        );

        drawChart(
            "ratingChart",
            "bar",
            [
                "1 Star",
                "2 Stars",
                "3 Stars",
                "4 Stars",
                "5 Stars"
            ],
            data.ratingCounts,
            "#14B8A6"
        );

        drawChart(
            "subjectChart",
            "bar",
            data.subjectLabels,
            data.subjectValues,
            "#102A33"
        );

        document.getElementById("status").textContent =
            "Live analytics updated successfully";

    } catch (error) {

        document.getElementById("status").textContent =
            "Unable to refresh analytics";

        console.error(error);
    }
}

updateDashboard();

setInterval(updateDashboard, 10000);

</script>

</body>
</html>
