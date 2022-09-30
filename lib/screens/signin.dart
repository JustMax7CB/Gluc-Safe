import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
            SigninForm(),
            Divider(
              height: 20,
              thickness: 2,
              indent: 70,
              endIndent: 70,
              color: Colors.grey,
            ),
            SignupText(),
          ],
        ),
      ),
    );
  }
}

class SignupText extends StatefulWidget {
  const SignupText({super.key});

  @override
  State<SignupText> createState() => _SignupTextState();
}

class _SignupTextState extends State<SignupText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextButton(
        onPressed: () {
          print("pressed");
          Navigator.pushNamed(context, "/register");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fiber_new),
            Text(
              "Or Signup Here",
              style: TextStyle(fontSize: 18, color: Colors.blueGrey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formkey = GlobalKey<FormState>();
  String _email = "";
  String _pass = "";

  Future checkLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _pass);
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid user data")));
    }
  }

  TextFormField textField(String field) {
    return TextFormField(
      decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          filled: true,
          icon:
              (field == "email") ? Icon(Icons.email_outlined) : Icon(Icons.key),
          hintStyle: const TextStyle(fontSize: 13),
          hintText: "Enter your $field",
          labelText: (field == "email") ? "Email" : "Password"),
      onChanged: (String val) {
        (field == "email") ? _email = val : _pass = val;
      },
      obscureText: (field == "password") ? true : false,
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Checking Data")));
                    FocusManager.instance.primaryFocus?.unfocus();

                    checkLogin();
                  }
                },
                child: const Text("Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
