enum MessageRole { user, assistant }

class ChatMessage {
  final MessageRole role;
  final String content;

  ChatMessage({required this.role, required this.content});
}
