import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_and_register/home.dart';
import 'package:flutter_login_and_register/register.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  String? emailErrorText;
  String? passwordErrorText;
  String? passwordConfirmErrorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  void onRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 60,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Email',
                    isDense: true,
                    errorText: emailErrorText,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    isDense: true,
                    errorText: passwordErrorText,
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: passwordConfirmController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    isDense: true,
                    errorText: passwordConfirmErrorText,
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                    onPressed: onRegister,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      child: Text('Next'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
