class SentimentService {
  final List<String> _positiveKeywords = ['happy', 'love', 'amazing', 'great', 'awesome', 'good', 'excited', 'fantastic', 'wonderful', 'joy', 'best', 'win', 'success', 'blessed'];
  final List<String> _negativeKeywords = ['sad', 'angry', 'terrible', 'bad', 'awful', 'hate', 'depressed', 'worst', 'fail', 'lose', 'upset', 'stress', 'stressful', 'annoyed'];

  String analyzeSentiment(String text) {
    String lowerText = text.toLowerCase();
    
    int positiveScore = 0;
    int negativeScore = 0;

    for (var word in _positiveKeywords) {
      if (lowerText.contains(word)) {
        positiveScore++;
      }
    }

    for (var word in _negativeKeywords) {
      if (lowerText.contains(word)) {
        negativeScore++;
      }
    }

    if (positiveScore > negativeScore) {
      return 'Positive 😊';
    } else if (negativeScore > positiveScore) {
      return 'Negative 😡';
    } else {
      return 'Neutral 😐';
    }
  }
}
