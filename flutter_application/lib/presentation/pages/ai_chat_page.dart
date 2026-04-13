import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_application/presentation/services/chat_service.dart';
import 'package:flutter_application/presentation/models/chat_message.dart';
import 'package:flutter_application/core/constants/app_constants.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ChatService _chatService = ChatService();
  bool _isLoading = false;

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(role: MessageRole.user, content: text));
      _controller.clear();
    });

    setState(() => _isLoading = true);
    try {
    // If you integrate Firebase Auth, obtain the user's ID token and pass it here:
    // final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    // final reply = await _chatService.sendMessage(text, idToken: idToken);
      final reply = await _chatService.sendMessage(text);
      setState(() {
        _messages.add(ChatMessage(role: MessageRole.assistant, content: reply));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(role: MessageRole.assistant, content: 'Sorry, something went wrong.'));
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If running on web and no server-proxy is configured, show a helpful warning.
    if (kIsWeb && AppConstants.openAiFunctionUrl.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Chat Support')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
              SizedBox(height: 16),
              Text('Server proxy is not configured', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text(
                'For security, the web app must call a server-side proxy to use OpenAI.\n\n'
                'Please deploy the Cloud Function and set `openAiFunctionUrl` in `lib/core/constants/app_constants.dart`.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text('Use the functions/README.md in the project for deploy steps.', textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat Support')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final align = m.role == MessageRole.user ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                final color = m.role == MessageRole.user ? Colors.blue[100] : Colors.grey[200];
                return Column(
                  crossAxisAlignment: align,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                      child: Text(m.content),
                    ),
                  ],
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: [
                  SizedBox(width: 40, child: LinearProgressIndicator(minHeight: 2)),
                  SizedBox(width: 8),
                  Text('Assistant is typing...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Ask about products, orders, shipping...'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(onPressed: _send, icon: const Icon(Icons.send)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
