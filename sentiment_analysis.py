
import re

class FeedbackAnalyzer:

    def __init__(self):
        self.positive_words = {
            "good", "excellent", "great", "helpful",
            "clear", "clearly", "best", "amazing",
            "friendly", "interesting", "supportive",
            "easy", "understandable", "perfect",
            "patient", "nice", "effective"
        }

        self.negative_words = {
            "bad", "poor", "boring", "confusing",
            "difficult", "worst", "rude", "unclear",
            "slow", "unhelpful", "terrible",
            "disappointing", "hard", "impatient"
        }

    def analyze(self, feedback):

        words = re.findall(r"[a-z]+", str(feedback).lower())

        positive_count = 0
        negative_count = 0

        for word in words:
            if word in self.positive_words:
                positive_count += 1
            elif word in self.negative_words:
                negative_count += 1

        if positive_count > negative_count:
            sentiment = "Positive"
        elif negative_count > positive_count:
            sentiment = "Negative"
        else:
            sentiment = "Neutral"

        return {
            "feedback": feedback,
            "positive_count": positive_count,
            "negative_count": negative_count,
            "sentiment": sentiment
        }


if __name__ == "__main__":

    analyzer = FeedbackAnalyzer()

    feedback_list = [
        "Teacher explains concepts clearly and is very helpful",
        "The teaching method is confusing and boring",
        "Teacher teaches Python",
        "Excellent teacher with great explanation",
        "The lecture was poor and difficult"
    ]

    print("SMART FEEDBACK SENTIMENT ANALYSIS")
    print("-" * 45)

    for feedback in feedback_list:
        result = analyzer.analyze(feedback)

        print("\nFeedback:", result["feedback"])
        print("Positive Words:", result["positive_count"])
        print("Negative Words:", result["negative_count"])
        print("Sentiment:", result["sentiment"])
