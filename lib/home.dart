import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_and_register/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final db = FirebaseFirestore.instance;
  late StreamSubscription<User?> subscribeUser;
  var userData = <String, dynamic>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (mounted) {
      subscribeUser =
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          print('email : ${user.email}');

          db
              .collection('users')
              .where('email', isEqualTo: user.email)
              .snapshots()
              .listen(
            (event) {
              setState(() {
                userData = event.docs.first.data();
              });
            },
          );
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    subscribeUser.cancel();
  }

  @override
  Widget build(BuildContext context) {
    void onLogout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text('Role : ${userData['role'] ?? ''}'),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome',
                          style: TextStyle(fontSize: 32),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red.shade300),
                          ),
                          onPressed: onLogout,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 13),
                            child: Text('Logout'),
                          ),
                        ),
                      ],
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
