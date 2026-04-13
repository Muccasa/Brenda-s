import 'package:flutter/material.dart';
import 'package:flutter_application/presentation/services/chat_service.dart';
import 'package:flutter_application/presentation/models/chat_message.dart';

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
