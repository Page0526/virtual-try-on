import 'package:go_router/go_router.dart';
import 'package:myapp/utils/const/graphic/color.dart';
import 'package:myapp/utils/const/graphic/size.dart';
import 'package:myapp/utils/helper/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ImagePicker _picker = ImagePicker();

  void _sendMessage() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({"user": text});
        _messages.add({"bot": "Hello"});
      });
      _controller.clear();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _messages.add({"user_image": image.path});
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final dark = Helper.isDarkMode(context);
    return Scaffold(
      
      appBar: AppBar(
        leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => context.go('/'),
              ),
        title: Text("FitAgent")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(CusSize.spaceBtwSections),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                String sender = _messages[index].keys.first;
                String message = _messages[index][sender]!;
                bool isUser = sender == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(CusSize.spaceBtwItems - 6.0),
                    decoration: BoxDecoration(

                      color: isUser ? CusColor.primaryColor : ( dark ? Colors.grey[300]: const Color.fromARGB(255, 122, 122, 122)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(color: isUser ? Colors.white : (dark ? Colors.black : Colors.white)),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(CusSize.spaceBtwItems, CusSize.spaceBtwItems, CusSize.spaceBtwItems, CusSize.spaceBtwItems * 2),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: dark ? const Color.fromARGB(255, 199, 199, 199) : const Color.fromARGB(255, 73, 73, 73)),
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
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: CusColor.primaryColor),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
