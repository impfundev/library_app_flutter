import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_app/src/widgets/ui/button_custom.dart';
import 'package:provider/provider.dart';

import 'package:library_app/src/providers/auth_provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpForm();
}

class _SignUpForm extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    const String title = "Sign In";
    const String formText = "Sign In to get started";

    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      final message = authProvider.message;

      return Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SvgPicture.asset(
              "assets/images/sign_up_image.svg",
              semanticsLabel: title,
              height: screenSize.height * 0.2,
            ),
          ),
          const Text(
            formText,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: "Enter your Username",
                      labelText: "Username",
                      suffixIcon: Icon(Icons.supervised_user_circle),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Enter your Email",
                      labelText: "Email",
                      suffixIcon: Icon(Icons.email_rounded),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      hintText: "Enter your Password",
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(message ?? "",
                        style: const TextStyle(color: Colors.red)),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ButtonCustom(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                            authProvider.signUp(
                              context,
                              usernameController.text,
                              emailController.text,
                              passwordController.text,
                            );
                          },
                          isLoading: authProvider.isLoading,
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
