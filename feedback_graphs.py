
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path

# Find project folder
folder = Path(__file__).resolve().parent

# Read actual analyzed feedback
df = pd.read_csv(folder / "analyzed_feedback.csv")

# Convert ratings to numbers
df["rating"] = pd.to_numeric(df["rating"], errors="coerce")

print("SMART FEEDBACK ANALYTICS")
print("-" * 40)
print("Total Feedback:", len(df))

if df.empty:
    print("No feedback records available.")
    raise SystemExit

print("Average Rating:", round(np.nanmean(df["rating"]), 2))

sns.set_theme(style="whitegrid")

# GRAPH 1: SENTIMENT PIE CHART

sentiment_counts = df["sentiment"].value_counts()

plt.figure(figsize=(7, 5))

plt.pie(
    sentiment_counts.values,
    labels=sentiment_counts.index,
    autopct="%1.1f%%",
    startangle=90
)

plt.title("Feedback Sentiment Distribution")
plt.tight_layout()
plt.savefig(folder / "sentiment_pie.png", dpi=300)
plt.show()

# GRAPH 2: TEACHER AVERAGE RATINGS

teacher_ratings = (
    df.groupby("teacher_name")["rating"]
    .mean()
    .reset_index()
)

plt.figure(figsize=(8, 5))

sns.barplot(
    data=teacher_ratings,
    x="teacher_name",
    y="rating",
    color="teal"
)

plt.title("Teacher Average Ratings")
plt.xlabel("Teacher Name")
plt.ylabel("Average Rating")
plt.ylim(0, 5)
plt.tight_layout()
plt.savefig(folder / "teacher_ratings.png", dpi=300)
plt.show()

# GRAPH 3: RATING DISTRIBUTION

plt.figure(figsize=(7, 5))

plt.hist(
    df["rating"].dropna(),
    bins=np.arange(0.5, 6.5, 1),
    color="teal",
    edgecolor="black"
)

plt.title("Student Rating Distribution")
plt.xlabel("Rating")
plt.ylabel("Number of Feedback")
plt.xticks([1, 2, 3, 4, 5])
plt.tight_layout()
plt.savefig(folder / "rating_distribution.png", dpi=300)
plt.show()

# GRAPH 4: SUBJECT-WISE FEEDBACK

subject_counts = df["subject_name"].value_counts()

plt.figure(figsize=(10, 5))

plt.bar(
    subject_counts.index,
    subject_counts.values,
    color="teal"
)

plt.title("Subject-wise Feedback Count")
plt.xlabel("Subject")
plt.ylabel("Feedback Count")
plt.xticks(rotation=20, ha="right")
plt.tight_layout()
plt.savefig(folder / "subject_feedback.png", dpi=300)
plt.show()

print("\nALL FOUR GRAPHS GENERATED SUCCESSFULLY!")
print("Saved in:", folder)
