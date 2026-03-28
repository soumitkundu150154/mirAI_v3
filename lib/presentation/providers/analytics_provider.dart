import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class AnalyticsState {
  final int likes;
  final int comments;
  final int shares;
  final List<double> weeklyEngagement; // Fake daily engagement points

  AnalyticsState({
    required this.likes,
    required this.comments,
    required this.shares,
    required this.weeklyEngagement,
  });

  factory AnalyticsState.initial() {
    return AnalyticsState(
      likes: 12450,
      comments: 320,
      shares: 89,
      weeklyEngagement: [4.0, 3.5, 6.0, 7.5, 5.0, 8.5, 10.0],
    );
  }



  AnalyticsState copyWith({
    int? likes,
    int? comments,
    int? shares,
    List<double>? weeklyEngagement,
  }) {
    return AnalyticsState(
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      weeklyEngagement: weeklyEngagement ?? this.weeklyEngagement,
    );
  }
}

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier() : super(AnalyticsState.initial());

  void generateNewStats() {
    final random = Random();
    state = state.copyWith(
      likes: 1000 + random.nextInt(20000),
      comments: 50 + random.nextInt(1000),
      shares: 10 + random.nextInt(200),
      weeklyEngagement: List.generate(7, (index) => 2.0 + random.nextDouble() * 8.0),
    );
  }
}

final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  return AnalyticsNotifier();
});
