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
        leading: const Icon(Icons.menu),
        actions: const [Icon(Icons.refresh)],
      ),
      body: const SigninForm(),
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

  TextFormField textField(String field) {
    return TextFormField(
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontSize: 13),
        hintText: "Enter your $field",
      ),
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
              textField("username"),
              textField("password"),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Checking Data")));
                    FocusManager.instance.primaryFocus?.unfocus();
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
