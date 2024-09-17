import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm_chatapp/services/auth/auth_service.dart';
import 'package:sm_chatapp/components/my_button.dart';
import 'package:sm_chatapp/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.goToSignUpPage});
  final void Function()? goToSignUpPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void userLogin() async {
    // authservice
    final AuthService authService = AuthService();

    // try login
    try {
      await authService.logIn(_emailController.text, _passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // chat app logo
              Transform.rotate(
                angle: 85,
                child: Icon(
                  Icons.message,
                  size: 70,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              const SizedBox(height: 50),
              // welcome message
              Text(
                "Welcome Back!",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              const SizedBox(height: 25),
              //email textfield
              MyTextField(
                hintText: "Type Email",
                obscureText: false,
                textController: _emailController,
              ),
              const SizedBox(height: 10),
              //password textfield
              MyTextField(
                hintText: "Type Password",
                obscureText: true,
                textController: _passwordController,
              ),
              const SizedBox(height: 25),

              //login button
              MyButton(
                text: "Log In",
                onTap: userLogin,
              ),
              const SizedBox(height: 25),

              //register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " Not a member?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  TextButton(
                      onPressed: widget.goToSignUpPage,
                      child: const Text(
                        "Sign Up Here!",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
