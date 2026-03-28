import 'package:dio/dio.dart';

class GeminiApiClient {
  final String _apiKey = 'AIzaSyCqNqpXrZVu35LIXyAbELNXJidJC8pOEgo';
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent';

  final Dio _dio;

  GeminiApiClient() : _dio = Dio() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<String> generateContent(
      {required String topic,
      required String platform,
      String? additionalInstruction}) async {
    try {
      String basePrompt =
          "Generate a viral $platform post about $topic with a caption and hashtags.";
      if (additionalInstruction != null && additionalInstruction.isNotEmpty) {
        basePrompt += " Make it $additionalInstruction.";
      }

      final body = {
        "contents": [
          {
            "parts": [
              {"text": basePrompt}
            ]
          }
        ]
      };

      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        data: body,
      );

      if (response.statusCode == 200) {
        final candidates = response.data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List;
          if (parts.isNotEmpty) {
            return parts[0]['text'] as String;
          }
        }
        return "No content generated. Try again.";
      } else {
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
