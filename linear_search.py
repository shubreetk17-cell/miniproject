
import pandas as pd
from pathlib import Path

folder = Path(__file__).resolve().parent

df = pd.read_csv(folder / "analyzed_feedback.csv")

feedback_list = df.to_dict("records")

def linear_search(feedbacks, keyword):
    results = []

    for feedback in feedbacks:
        comment = str(feedback["comments"]).lower()

        if keyword.lower() in comment:
            results.append(feedback)

    return results


keyword = input("Enter keyword to search: ").strip()

if not keyword:
    print("Please enter a keyword.")
else:
    matches = linear_search(feedback_list, keyword)

    print("\nLINEAR SEARCH RESULTS")
    print("-" * 45)

    if matches:
        for item in matches:
            print("Teacher:", item["teacher_name"])
            print("Subject:", item["subject_name"])
            print("Feedback:", item["comments"])
            print("Sentiment:", item["sentiment"])
            print("-" * 45)
    else:
        print("No matching feedback found.")

    print("Total Matches:", len(matches))