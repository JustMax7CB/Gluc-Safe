import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        centerTitle: true,
        title: const Text(
          "Gluc-Safe",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Gluc-Safe",
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SignupForm(),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formkey = GlobalKey<FormState>();
  String _email = "";
  String _pass = "";
  String _passConfirm = "";

  Future checkRegister() async {
    try {
      if (_pass == _passConfirm) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _pass);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords doesn't match")));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid user data")));
    }
    Navigator.pop(context);
  }

  TextFormField textField(String field) {
    return TextFormField(
      decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          filled: true,
          icon:
              (field == "email") ? Icon(Icons.email_outlined) : Icon(Icons.key),
          hintStyle: const TextStyle(fontSize: 13),
          hintText: (field == "email")
              ? "Enter your email"
              : (field == "password")
                  ? "Enter your password"
                  : "Confirm your password",
          labelText: (field == "email") ? "Email" : "Password"),
      onChanged: (String val) {
        (field == "email")
            ? _email = val
            : (field == "password")
                ? _pass = val
                : _passConfirm = val;
      },
      obscureText: (field.contains("password")) ? true : false,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "$field cannot be empty";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double formFieldSize = MediaQuery.of(context).size.width -
        (MediaQuery.of(context).size.width * 0.15);
    return Container(
      margin: EdgeInsets.only(
          left: 20, top: MediaQuery.of(context).size.height / 4),
      width: formFieldSize,
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              textField("email"),
              textField("password"),
              textField("confirm password"),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Checking Data")));
                    FocusManager.instance.primaryFocus?.unfocus();
                    checkRegister();
                  }
                },
                child: const Text("Signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
