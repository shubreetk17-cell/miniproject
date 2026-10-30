
import pandas as pd
from pathlib import Path
from sentiment_analysis import FeedbackAnalyzer

# Locate the folder containing this Python file
folder = Path(__file__).resolve().parent

# CSV file path
csv_file = folder / "feedback_data.csv"

if not csv_file.exists():
    print("ERROR: feedback_data.csv not found!")
    print("Expected location:", csv_file)
    raise SystemExit

# Read actual feedback from CSV
df = pd.read_csv(csv_file, encoding="utf-8-sig")

# Check required columns
required_columns = [
    "teacher_name",
    "subject_name",
    "rating",
    "comments"
]

for column in required_columns:
    if column not in df.columns:
        print("ERROR: Missing column:", column)
        print("Available columns:", list(df.columns))
        raise SystemExit

# Create analyzer object
analyzer = FeedbackAnalyzer()

# Handle empty comments
df["comments"] = df["comments"].fillna("")

# Analyze each feedback
results = df["comments"].apply(analyzer.analyze)

df["positive_count"] = results.apply(
    lambda x: x["positive_count"]
)

df["negative_count"] = results.apply(
    lambda x: x["negative_count"]
)

df["sentiment"] = results.apply(
    lambda x: x["sentiment"]
)

# Display results
print("\nSMART FEEDBACK SENTIMENT ANALYSIS")
print("=" * 55)

print("Total Feedback:", len(df))

print("\nFEEDBACK DETAILS")
print(df[[
    "teacher_name",
    "subject_name",
    "rating",
    "comments",
    "sentiment"
]].to_string(index=False))

# Sentiment summary
print("\nSENTIMENT SUMMARY")
print(df["sentiment"].value_counts())

# Calculate average rating
df["rating"] = pd.to_numeric(
    df["rating"], errors="coerce"
)

print("\nAverage Rating:", round(df["rating"].mean(), 2))

# Save results
output_file = folder / "analyzed_feedback.csv"

df.to_csv(output_file, index=False)

print("\nSUCCESS: Analysis completed!")
print("Results saved at:", output_file)
