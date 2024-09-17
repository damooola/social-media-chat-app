import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm_chatapp/services/auth/auth_service.dart';
import 'package:sm_chatapp/components/my_button.dart';
import 'package:sm_chatapp/components/my_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.goToLoginPage});
  final void Function()? goToLoginPage;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void userSignUp() async {
    AuthService authService = AuthService();

    // check if passwords match
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await authService.signUp(
            _emailController.text, _passwordController.text);
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
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
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
              // big logo
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
                "Join Us!",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              const SizedBox(height: 25),
              //email textfeield
              MyTextField(
                hintText: "Type Email",
                obscureText: false,
                textController: _emailController,
              ),
              const SizedBox(height: 13),
              //password textfield
              MyTextField(
                hintText: "Type Password",
                obscureText: true,
                textController: _passwordController,
              ),
              const SizedBox(height: 10),
              //confirm password textfield
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                textController: _confirmPasswordController,
              ),

              const SizedBox(height: 30),

              //login button
              MyButton(
                text: "Sign Up",
                onTap: userSignUp,
              ),
              const SizedBox(height: 25),

              //register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " Already have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  TextButton(
                      onPressed: widget.goToLoginPage,
                      child: const Text(
                        "Login Now!",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
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
