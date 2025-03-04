import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  void sendMessage(String text) async {
    if (text.isEmpty) return;
    _messages.add(Message(text: text, isUser: true));
    notifyListeners();

    String response = await fetchAIResponse(text);
    _messages.add(Message(text: response, isUser: false));
    notifyListeners();
  }

  Future<String> fetchAIResponse(String text) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer YOUR_OPENAI_API_KEY',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": text}
        ]
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse["choices"][0]["message"]["content"];
    } else {
      return "Lỗi khi gọi API";
    }
  }
}
