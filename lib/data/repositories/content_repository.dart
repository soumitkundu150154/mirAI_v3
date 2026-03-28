import '../api/gemini_api_client.dart';

class ContentRepository {
  final GeminiApiClient _apiClient;

  ContentRepository(this._apiClient);

  Future<String> getPostContent({required String topic, required String platform, String? additionalInstruction}) async {
    return await _apiClient.generateContent(
      topic: topic,
      platform: platform,
      additionalInstruction: additionalInstruction,
    );
  }
}
