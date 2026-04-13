import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application/core/constants/app_constants.dart';

class ChatService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  static const String _systemPrompt = '''
You are a helpful customer support agent for Brendas.
Be friendly, concise, and professional.
If you cannot help with something, politely direct the user to contact support@yourcompany.com.
''';

  final List<Map<String, String>> _conversationHistory = [
    {'role': 'system', 'content': _systemPrompt}
  ];

  Future<String> sendMessage(String userMessage, {String? idToken}) async {
    _conversationHistory.add({'role': 'user', 'content': userMessage});
    // If a server-side proxy is configured, call it instead of direct client call.
    if (AppConstants.openAiFunctionUrl.isNotEmpty) {
      try {
        final headers = {'Content-Type': 'application/json'};
        if (idToken != null && idToken.isNotEmpty) {
          headers['Authorization'] = 'Bearer $idToken';
        }

        final res = await http.post(
          Uri.parse(AppConstants.openAiFunctionUrl),
          headers: headers,
          body: jsonEncode({'prompt': userMessage, 'history': _conversationHistory}),
        ).timeout(const Duration(seconds: 15));

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final reply = data['reply'] as String?;
          if (reply != null) {
            _conversationHistory.add({'role': 'assistant', 'content': reply});
            return reply;
          }
          throw Exception('Proxy returned unexpected response');
        } else {
          throw Exception('Proxy error: ${res.statusCode}');
        }
      } catch (e) {
        // if proxy fails, fall back to client-side OpenAI (useful for local dev)
        // but log/throw if you prefer strict proxy-only behavior.
      }
    }

    // Fallback: direct client-side OpenAI call using dotenv key (dev only)
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) throw Exception('OPENAI_API_KEY not found in .env');

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': _conversationHistory,
        'max_tokens': 500,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'] as String?;

      if (reply != null) {
        _conversationHistory.add({'role': 'assistant', 'content': reply});
        return reply;
      }
      throw Exception('OpenAI returned unexpected response');
    } else {
      throw Exception('Failed to get response: ${response.statusCode}');
    }
  }

  void clearHistory() {
    _conversationHistory.clear();
    _conversationHistory.add({'role': 'system', 'content': _systemPrompt});
  }
}
