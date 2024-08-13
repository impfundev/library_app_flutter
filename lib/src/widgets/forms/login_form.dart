import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/widgets/ui/button_custom.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
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
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    const String title = "Log In";
    const String formText = "Log In to continue";

    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      final isInvalidUsernameOrPassword =
          authProvider.invalidUsernameOrPassword;

      return Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SvgPicture.asset(
              "assets/images/login_image.svg",
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
                    child: Text(
                      isInvalidUsernameOrPassword
                          ? "Invalid username or password"
                          : "",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ButtonCustom(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {}
                            authProvider.signIn(
                              context,
                              usernameController.text,
                              passwordController.text,
                            );
                          },
                          isLoading: authProvider.isLoading,
                          child: const Text("Submit"),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: const Text("Sign Up"),
                          onPressed: () => context.go("/sign-up"),
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
