import 'package:chatapp/api/api1.dart';
import 'package:chatapp/mes.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

final controllerphno = TextEditingController();
final controllerpassword = TextEditingController();

class _LoginState extends State<LoginPage> {
  List accounts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showAccount().then((v) {
      setState(() {
        accounts = v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 300,
                margin: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter phone number",
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.call),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  controller: controllerphno,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 300,
                margin: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.key),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  controller: controllerpassword,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  for (var a in accounts) {
                    if (a["phno"] == int.parse(controllerphno.text.trim()) &&
                        a["password"] == controllerpassword.text) {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("phno", a["phno"].toString());
                      prefs.setString("password", a["password"]);
                      prefs.setString("id", a["id"].toString());
                      successMessage(context, "Login Successfully");
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                      return;
                    }
                  }
                  errorMessage(context, "Invalid phone number or password");
                },
                child: Container(
                  height: 50,
                  width: 300,
                  padding: EdgeInsets.only(left: 10),
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: 60,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Don't have an account?")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text("Sign up", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
