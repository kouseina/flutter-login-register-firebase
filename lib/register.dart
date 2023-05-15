import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_and_register/home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

final List<String> roleList = <String>['Admin', 'User'];

class _RegisterState extends State<Register> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String roleValue = roleList.first;

  bool isLoading = false;

  String? nameErrorText;
  String? emailErrorText;
  String? passwordErrorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onRegister() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        final user = <String, dynamic>{
          "name": nameController.value.text,
          "email": emailController.value.text,
          "role": roleValue
        };

        await db.collection('users').add(user).then((doc) {
          print('DocumentSnapshot added with ID: ${doc.id}');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Register success'),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        print(e.code);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? ''),
        ));

        ///
        if (e.code == 'weak-password') {
          setState(() {
            passwordErrorText = 'The password provided is too weak.';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            emailErrorText = 'The account already exists for that email.';
          });
        }
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      isLoading = false;
    });
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
                  height: MediaQuery.of(context).size.height / 7,
                ),
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 60,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          onChanged: (value) {
                            setState(() {
                              nameErrorText = null;
                            });
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Name',
                            isDense: true,
                            errorText: nameErrorText,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: emailController,
                          onChanged: (value) {
                            setState(() {
                              emailErrorText = null;
                            });
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Email is required';
                            }
                            return null;
                          },
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
                        Stack(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              width: double.infinity,
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  value: roleValue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  isExpanded: true,
                                  elevation: 16,
                                  underline: const SizedBox(),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      roleValue = value!;
                                    });
                                  },
                                  items: roleList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              color: Colors.white,
                              transform: Matrix4.translationValues(10, -6, 0),
                              child: const Text(
                                'Role',
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: passwordController,
                          onChanged: (value) {
                            setState(() {
                              passwordErrorText = null;
                            });
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            isDense: true,
                            errorText: passwordErrorText,
                          ),
                          obscureText: true,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                    onPressed: onRegister,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Next'),
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
