import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/gemini_api_client.dart';
import '../../data/repositories/content_repository.dart';
import '../../domain/services/sentiment_service.dart';

// Dependency Providers
final apiClientProvider = Provider((ref) => GeminiApiClient());

final contentRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ContentRepository(apiClient);
});

final sentimentServiceProvider = Provider((ref) => SentimentService());

// State class
class ContentState {
  final bool isGenerating;
  final String? error;
  final String? generatedText;
  final String? sentiment;

  ContentState({
    this.isGenerating = false,
    this.error,
    this.generatedText,
    this.sentiment,
  });

  ContentState copyWith({
    bool? isGenerating,
    String? error,
    String? generatedText,
    String? sentiment,
    bool clearError = false,
  }) {
    return ContentState(
      isGenerating: isGenerating ?? this.isGenerating,
      error: clearError ? null : (error ?? this.error),
      generatedText: generatedText ?? this.generatedText,
      sentiment: sentiment ?? this.sentiment,
    );
  }
}

// Notifier
class ContentNotifier extends StateNotifier<ContentState> {
  final ContentRepository _repository;
  final SentimentService _sentimentService;

  ContentNotifier(this._repository, this._sentimentService) : super(ContentState());

  Future<void> generatePost({required String topic, required String platform, String? additionalInstruction}) async {
    state = state.copyWith(isGenerating: true, clearError: true);

    try {
      final text = await _repository.getPostContent(
        topic: topic,
        platform: platform,
        additionalInstruction: additionalInstruction,
      );

      final sentiment = _sentimentService.analyzeSentiment(text);

      state = state.copyWith(
        isGenerating: false,
        generatedText: text,
        sentiment: sentiment,
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        error: e.toString(),
      );
    }
  }

  void clearContent() {
    state = ContentState();
  }
}

final contentNotifierProvider = StateNotifierProvider<ContentNotifier, ContentState>((ref) {
  final repository = ref.watch(contentRepositoryProvider);
  final sentimentService = ref.watch(sentimentServiceProvider);
  return ContentNotifier(repository, sentimentService);
});
