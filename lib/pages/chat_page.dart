import 'dart:io';

import 'package:chatapp/api/api2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.contact});
  final Map contact;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? path;
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    setState(() {
      path = result?.files.firstOrNull?.path;
      print(path);
    });
  }

  final controller_text = TextEditingController();
  final sender_name = TextEditingController();
  int sId = 0;
  Timer? _timer;
  List message = [];

  @override
  void initState() {
    super.initState();
    sender_name.text = widget.contact['name'];
    sid();
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      getChats();
    });
  }

  Future<void> sid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    setState(() {
      sId = int.parse(id ?? '0');
    });
  }

  void getChats() {
    if (sId == 0) return;

    messageList(reciver_id: widget.contact['id'], sender_id: sId).then((v) {
      messageList(sender_id: widget.contact['id'], reciver_id: sId).then((v1) {
        List all = [...v, ...v1];
        Map<int, dynamic> uniqueMap = {};
        for (var e in all) {
          uniqueMap[e['id']] = e;
        }

        List finalList = uniqueMap.values.toList();
        finalList.sort(
          (a, b) => DateTime.parse(
            a['created_at'].toString(),
          ).compareTo(DateTime.parse(b['created_at'].toString())),
        );

        final updatedMessages =
            finalList
                .map(
                  (e) => {
                    "message": e['message'],
                    "left": !(e['sender_id'] == sId),
                  },
                )
                .toList();

        setState(() {
          message = updatedMessages;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            Text(sender_name.text, style: TextStyle(fontSize: 20)),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: PopupMenuButton<SampleItem>(
              onSelected: (SampleItem item) async {
                if (item == SampleItem.itemThree) {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text("Clear Chat"),
                          content: Text(
                            "Are you sure you want to delete all messages?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true) {
                    final success = await deletemassage(
                      sender_id: sId,
                      reciver_id: widget.contact['id'],
                    );
                    if (success) {
                      setState(() {
                        message.clear();
                      });
                    }
                  }
                }
              },
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                    const PopupMenuItem<SampleItem>(
                      value: SampleItem.itemOne,
                      child: Text('Send files'),
                    ),
                    const PopupMenuItem<SampleItem>(
                      value: SampleItem.itemTwo,
                      child: Text('Video call'),
                    ),
                    const PopupMenuItem<SampleItem>(
                      value: SampleItem.itemThree,
                      child: Text('Clear chat'),
                    ),
                  ],
              child: Icon(Icons.more_horiz),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment:
                        message[index]["left"]
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    child: Text(
                      message[index]["message"],
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
              itemCount: message.length,
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
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter message",
                    hintStyle: TextStyle(color: Colors.blue),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  onChanged: (v) {
                    setState(() {});
                  },
                  controller: controller_text,
                ),
              ),
              if (controller_text.text.isNotEmpty)
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final msg = controller_text.text;
                      await addmessage(
                        reciver_id: widget.contact['id'],
                        sender_id: sId,
                        message: msg,
                      );

                      setState(() {
                        message.add({"message": msg, "left": false});
                        controller_text.text = "";
                      });

                      Future.delayed(Duration(seconds: 1), () {
                        getChats();
                      });
                    },
                    icon: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              if (controller_text.text.isEmpty)
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue,
                  ),
                  child: Icon(Icons.voice_chat, color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// You probably have this defined elsewhere
enum SampleItem { itemOne, itemTwo, itemThree }
