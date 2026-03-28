import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class RecentPost {
  final String title;
  final String platform;
  final int likes;
  final int comments;
  final int shares;
  final String sentiment;
  final DateTime date;

  RecentPost({
    required this.title,
    required this.platform,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.sentiment,
    required this.date,
  });
}

class AnalyticsState {
  final int likes;
  final int comments;
  final int shares;
  final List<double> weeklyEngagement;
  final double positivePercent;
  final double neutralPercent;
  final double negativePercent;
  final List<RecentPost> recentPosts;
  final double growthPercent;

  AnalyticsState({
    required this.likes,
    required this.comments,
    required this.shares,
    required this.weeklyEngagement,
    required this.positivePercent,
    required this.neutralPercent,
    required this.negativePercent,
    required this.recentPosts,
    required this.growthPercent,
  });

  factory AnalyticsState.initial() {
    return AnalyticsState(
      likes: 12450,
      comments: 320,
      shares: 89,
      weeklyEngagement: [4.0, 3.5, 6.0, 7.5, 5.0, 8.5, 10.0],
      positivePercent: 72.0,
      neutralPercent: 18.0,
      negativePercent: 10.0,
      growthPercent: 14.2,
      recentPosts: _generateInitialPosts(),
    );
  }

  static List<RecentPost> _generateInitialPosts() {
    return [
      RecentPost(
        title: '5 Tips for Better Flutter Apps',
        platform: 'Instagram',
        likes: 2340,
        comments: 89,
        shares: 34,
        sentiment: 'Positive',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RecentPost(
        title: 'Why AI is the Future of Content',
        platform: 'LinkedIn',
        likes: 1820,
        comments: 156,
        shares: 67,
        sentiment: 'Positive',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      RecentPost(
        title: 'Debugging Horror Stories 😱',
        platform: 'Twitter',
        likes: 4500,
        comments: 230,
        shares: 120,
        sentiment: 'Neutral',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      RecentPost(
        title: 'Morning Coding Routine ☀️',
        platform: 'Instagram',
        likes: 890,
        comments: 45,
        shares: 12,
        sentiment: 'Positive',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  AnalyticsState copyWith({
    int? likes,
    int? comments,
    int? shares,
    List<double>? weeklyEngagement,
    double? positivePercent,
    double? neutralPercent,
    double? negativePercent,
    List<RecentPost>? recentPosts,
    double? growthPercent,
  }) {
    return AnalyticsState(
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      weeklyEngagement: weeklyEngagement ?? this.weeklyEngagement,
      positivePercent: positivePercent ?? this.positivePercent,
      neutralPercent: neutralPercent ?? this.neutralPercent,
      negativePercent: negativePercent ?? this.negativePercent,
      recentPosts: recentPosts ?? this.recentPosts,
      growthPercent: growthPercent ?? this.growthPercent,
    );
  }
}

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier() : super(AnalyticsState.initial());

  void generateNewStats() {
    final random = Random();
    final newLikes = 1000 + random.nextInt(20000);
    final newComments = 50 + random.nextInt(1000);
    final newShares = 10 + random.nextInt(200);
    final positive = 40.0 + random.nextDouble() * 40;
    final negative = random.nextDouble() * 20;
    final neutral = 100 - positive - negative;

    final platforms = ['Instagram', 'LinkedIn', 'Twitter'];
    final sentiments = ['Positive', 'Neutral', 'Negative'];
    final titles = [
      'How to Grow Your Audience Fast',
      'Top 10 Coding Tricks',
      'Day in the Life of a Creator',
      'Stop Making This Mistake! 🚫',
      'Why I Switched to Flutter',
      'Unpopular Programming Opinions',
    ];

    state = state.copyWith(
      likes: newLikes,
      comments: newComments,
      shares: newShares,
      weeklyEngagement: List.generate(7, (index) => 2.0 + random.nextDouble() * 8.0),
      positivePercent: double.parse(positive.toStringAsFixed(1)),
      neutralPercent: double.parse(neutral.abs().toStringAsFixed(1)),
      negativePercent: double.parse(negative.toStringAsFixed(1)),
      growthPercent: double.parse((-5 + random.nextDouble() * 30).toStringAsFixed(1)),
      recentPosts: List.generate(
        4,
        (i) => RecentPost(
          title: titles[random.nextInt(titles.length)],
          platform: platforms[random.nextInt(3)],
          likes: 100 + random.nextInt(5000),
          comments: 10 + random.nextInt(300),
          shares: 5 + random.nextInt(150),
          sentiment: sentiments[random.nextInt(3)],
          date: DateTime.now().subtract(Duration(days: i + 1)),
        ),
      ),
    );
  }
}

final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  return AnalyticsNotifier();
});
