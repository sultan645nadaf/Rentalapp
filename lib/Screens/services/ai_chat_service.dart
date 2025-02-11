import 'dart:convert';
import 'package:http/http.dart' as http;

class AIChatService {
  // **DO NOT REPLACE THIS WITH AN ACTUAL GEMINI API KEY**
  // It is against Google's AI Principles to distribute API keys.
  // You'll need to obtain your own API key from Gemini.
  final String apiKey = 'AIzaSyAVuTT5RXc0SbHKIbqH69kNzzftPduBHPI';

  Future<String> getAIResponse(String userMessage) async {
    final url = Uri.parse('https://api.gemini.ai/v1/models/text-embedding-004/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = json.encode({
      'model': 'text-embedding-004',
      'prompt': userMessage,
      'max_tokens': 150,
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      throw Exception('Failed to load AI response');
    }
  }
}
