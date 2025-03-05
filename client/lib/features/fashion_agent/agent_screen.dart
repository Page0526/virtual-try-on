import 'dart:io';
import 'package:client_1/features/fashion_agent/chat_provider.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:client_1/utils/const/size.dart';
import 'package:client_1/utils/helper/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).sendMessage(text);
      _controller.clear();
      
      // Scroll to bottom after message is sent
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await Provider.of<ChatProvider>(context, listen: false)
          .sendImageMessage(File(image.path));
      
      // Scroll to bottom after image is sent
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Helper.isDarkMode(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("FitAgent"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false).clearChat();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(CusSize.spaceBtwSections),
                  itemCount: chatProvider.messages.length + (chatProvider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator
                    if (chatProvider.isLoading && index == chatProvider.messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(CusSize.spaceBtwItems - 6.0),
                          decoration: BoxDecoration(
                            color: dark ? Colors.grey[800] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: dark ? Colors.white : CusColor.primaryColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Đang suy nghĩ...",
                                style: TextStyle(
                                  color: dark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final message = chatProvider.messages[index];
                    final isUser = message.isUser;
                    
                    Widget messageContent;
                    
                    if (message.imagePath != null) {
                      messageContent = InkWell(
                        onTap: () {
                          // Show full-screen image when tapped
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Image.file(File(message.imagePath!)),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(message.imagePath!),
                                height: 150,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (message.text.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  message.text,
                                  style: TextStyle(
                                    color: isUser ? Colors.white : (dark ? Colors.white : Colors.black),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    } else {
                      messageContent = Text(
                        message.text,
                        style: TextStyle(
                          color: isUser ? Colors.white : (dark ? Colors.white : Colors.black),
                        ),
                      );
                    }
                    
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(CusSize.spaceBtwItems - 6.0),
                        decoration: BoxDecoration(
                          color: isUser 
                              ? CusColor.primaryColor 
                              : (dark ? Colors.grey[800] : Colors.grey[300]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: messageContent,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              CusSize.spaceBtwItems, 
              CusSize.spaceBtwItems, 
              CusSize.spaceBtwItems, 
              CusSize.spaceBtwItems * 2
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.image,
                    color: dark 
                        ? const Color.fromARGB(255, 199, 199, 199) 
                        : const Color.fromARGB(255, 73, 73, 73),
                  ),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask anything...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(CusSize.borderRadiusMd),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    return IconButton(
                      icon: Icon(
                        Icons.send, 
                        color: chatProvider.isLoading 
                            ? Colors.grey 
                            : CusColor.primaryColor,
                      ),
                      onPressed: chatProvider.isLoading ? null : _sendMessage,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}