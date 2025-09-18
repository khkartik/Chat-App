import 'package:chatapp/api/api3.dart';
import 'package:flutter/material.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final controller_text = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  void sendMessage(String msg) async {
    setState(() {
      messages.add({"message": msg, "left": false});
      controller_text.clear();
    });

    final reply = await getGeminiReply(msg);

    setState(() {
      messages.add({"message": reply, "left": true});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini AI"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Align(
                    alignment:
                        msg["left"]
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            msg["left"] ? Colors.grey[300] : Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        msg["message"],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 50,
                width: 300,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: controller_text,
                  decoration: InputDecoration(
                    hintText: "Ask something...",
                    hintStyle: TextStyle(color: Colors.blue),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  onChanged: (v) => setState(() {}),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blue,
                ),
                child: IconButton(
                  onPressed:
                      controller_text.text.isNotEmpty
                          ? () => sendMessage(controller_text.text)
                          : null,
                  icon: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
