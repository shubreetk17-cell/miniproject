
import pandas as pd
from pathlib import Path

folder = Path(__file__).resolve().parent

df = pd.read_csv(folder / "analyzed_feedback.csv")

df["rating"] = pd.to_numeric(df["rating"], errors="coerce")
df = df.dropna(subset=["rating"])

teacher_ratings = (
    df.groupby("teacher_name", as_index=False)["rating"]
    .mean()
    .to_dict("records")
)

def merge_sort(arr):
    if len(arr) <= 1:
        return arr

    mid = len(arr) // 2

    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])

    return merge(left, right)


def merge(left, right):
    result = []
    i = 0
    j = 0

    while i < len(left) and j < len(right):

        if left[i]["rating"] >= right[j]["rating"]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    result.extend(left[i:])
    result.extend(right[j:])

    return result


sorted_teachers = merge_sort(teacher_ratings)

print("\nTEACHER RANKING USING MERGE SORT")
print("-" * 45)

for rank, teacher in enumerate(sorted_teachers, start=1):
    print(
        rank,
        teacher["teacher_name"],
        "- Average Rating:",
        round(teacher["rating"], 2)
    )

output = pd.DataFrame(sorted_teachers)
output.to_csv(folder / "teacher_ranking.csv", index=False)

print("\nTeacher ranking saved successfully!")
