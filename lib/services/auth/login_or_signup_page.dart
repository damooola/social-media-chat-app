import 'package:flutter/material.dart';
import 'package:sm_chatapp/pages/login_page.dart';
import 'package:sm_chatapp/pages/sign_up_page.dart';

class LoginOrSignUpPage extends StatefulWidget {
  const LoginOrSignUpPage({super.key});

  @override
  State<LoginOrSignUpPage> createState() => _LoginOrSignUpPageState();
}

class _LoginOrSignUpPageState extends State<LoginOrSignUpPage> {
  // initially set the page to login page
  bool showLoginPage = true;

  // toggle between the pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        goToSignUpPage: togglePages,
      );
    } else {
      return SignUpPage(
        goToLoginPage: togglePages,
      );
    }
  }
}
