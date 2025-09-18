import 'package:chatapp/api/api1.dart';
import 'package:chatapp/mes.dart';
import 'package:chatapp/pages/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _SignState();
}

class _SignState extends State<RegisterPage> {
  final name = TextEditingController();
  final phno = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: double.infinity,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
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
                    "Create Account",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
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
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter name",
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.account_box),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  controller: name,
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
                margin: EdgeInsets.only(top: 30),
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
                  controller: phno,
                  keyboardType: TextInputType.number,
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
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.account_box),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  controller: password,
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
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      if (name.text.isEmpty) {
                        errorMessage(context, "invalid name");
                        return;
                      }
                      if (phno.text.isEmpty) {
                        errorMessage(context, "invalid phone numebr");
                        return;
                      }
                      if (password.text.isEmpty) {
                        errorMessage(context, "Create a password");
                        return;
                      }
                      successMessage(context, "Create account successfully");
                      addAccount(
                        name: name.text,
                        phno: int.parse(phno.text.toString()),
                        password: password.text,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Sign Up",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
