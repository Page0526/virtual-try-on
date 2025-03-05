import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Message {
  final String text;
  final bool isUser;
  final String? imagePath;

  Message({required this.text, required this.isUser, this.imagePath});
}

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  String? _sessionId;
  bool _isLoading = false;
  
  // URL của API FastAPI - thay đổi IP này thành IP của máy chủ của bạn
  final String apiUrl = 'http://10.0.2.2:8000/chat'; // 10.0.2.2 cho máy ảo Android
  
  List<Message> get messages => _messages;
  String? get sessionId => _sessionId;
  bool get isLoading => _isLoading;

  void sendMessage(String text) async {
    if (text.isEmpty) return;
    
    // Thêm tin nhắn người dùng vào danh sách
    _messages.add(Message(text: text, isUser: true));
    notifyListeners();
    
    // Bắt đầu trạng thái đang tải
    _isLoading = true;
    notifyListeners();
    
    try {
      String response = await fetchAIResponse(text);
      _messages.add(Message(text: response, isUser: false));
    } catch (e) {
      _messages.add(Message(text: "Lỗi: Không thể kết nối đến server. $e", isUser: false));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> sendImageMessage(File image) async {
    // Thêm tin nhắn hình ảnh của người dùng
    _messages.add(Message(text: "Đã gửi hình ảnh", isUser: true, imagePath: image.path));
    notifyListeners();
    
    // TODO: Implement image upload to FastAPI
    _messages.add(Message(text: "Đã nhận hình ảnh của bạn. Tính năng này đang được phát triển.", isUser: false));
    notifyListeners();
  }

  Future<String> fetchAIResponse(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "message": text,
          "session_id": _sessionId
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // Lưu session_id từ phản hồi
        _sessionId = jsonResponse["session_id"];
        return jsonResponse["response"];
      } else {
        return "Lỗi từ server: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Lỗi kết nối: $e";
    }
  }
  
  void clearChat() {
    _messages.clear();
    _endSession();
    notifyListeners();
  }
  
  Future<void> _endSession() async {
    if (_sessionId != null) {
      try {
        await http.delete(
          Uri.parse('http://10.0.2.2:8000/sessions/$_sessionId'),
        );
        _sessionId = null;
      } catch (e) {
        print("Lỗi khi kết thúc phiên chat: $e");
      }
    }
  }
  
  @override
  void dispose() {
    _endSession();
    super.dispose();
  }
}