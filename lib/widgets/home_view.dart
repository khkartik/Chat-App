import 'package:chatapp/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chatapp/pages/ai_page.dart';
import 'package:chatapp/api/api1.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLiked = false;
  List localContacts = [];

  @override
  void initState() {
    super.initState();
    askContactPermission();
  }

  Future<void> askContactPermission() async {
    if (await Permission.contacts.request().isGranted) {
      print("Permission Granted");
      fetchLocalContacts();
    } else {
      print("Permission Denied");
    }
  }

  Future<void> fetchLocalContacts() async {
    if (await FlutterContacts.requestPermission(readonly: true)) {
      print("Fetching Local Contacts...");
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      localContacts.clear();

      final serverContacts = await showAccount();
      for (var sc in serverContacts) {
        for (var c in contacts) {
          String phone = c.phones.firstOrNull?.normalizedNumber ?? "";
          phone =
              phone.length > 10 ? phone.substring(phone.length - 10) : phone;
          String fullName = "${c.name.first} ${c.name.last}";
          if (phone.isEmpty) continue;

          if (sc["phno"].toString().trim().toLowerCase().endsWith(
            phone.toLowerCase().trim(),
          )) {
            var contactData = Map<String, dynamic>.from(sc);
            contactData["name"] = fullName;
            localContacts.add(contactData);
            print("Matched Contact: $c");
            break;
          }
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Custom Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  "Chats",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    color: isLiked ? Colors.blue : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: localContacts.length,
                itemExtent: 50,
                itemBuilder: (context, index) {
                  final contact = localContacts[index];
                  return GestureDetector(
                    onTap: () {
                      print("Hello");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(contact: contact),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      alignment: Alignment.centerLeft,
                      color: Colors.white70,
                      child: Text(
                        contact["name"],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 100),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AiChatPage()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.smart_toy, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
