import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/widgets/ui/button_custom.dart';
import 'package:provider/provider.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordForm();
}

class _ResetPasswordForm extends State<ResetPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const String title = "Reset Password";
    const String formText = "Confirm your email to continue reset password";

    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      final message = authProvider.message;

      return Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/reset_password_image.svg",
                  semanticsLabel: title,
                  width: 200,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  formText,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 30.0,
              ),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                        }
                        return null;
                      },
                    ),
                    Text(
                      message ?? "",
                      style: const TextStyle(color: Colors.red),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ButtonCustom(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {}
                                authProvider.resetPassword(
                                    context, emailController.text);
                              },
                              isLoading: authProvider.isLoading,
                              child: const Text("Submit"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}

class ConfirmResetPasswordForm extends StatefulWidget {
  const ConfirmResetPasswordForm({super.key});

  @override
  State<ConfirmResetPasswordForm> createState() => _ConfirmResetPasswordForm();
}

class _ConfirmResetPasswordForm extends State<ConfirmResetPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    const String title = "Confirm Reset Password Pin";
    const String formText = "Enter the pin that we just sent to your email";

    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      final message = authProvider.message;
      return Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/reset_password_image.svg",
                  semanticsLabel: title,
                  width: 200,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  formText,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 30.0,
              ),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: pinController,
                      decoration: const InputDecoration(
                        hintText: "Enter your confirmation pin",
                        labelText: "confirmation pin",
                        suffixIcon: Icon(Icons.password),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (String? value) {
                        if (value == null) {
                          return "Please enter your pin";
                        } else if (value is int) {
                          return "Please enter pin in number";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: password1Controller,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        hintText: "Enter your new Password",
                        labelText: "New Password",
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
                    TextFormField(
                      controller: password2Controller,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        hintText: "Confirm your new Password",
                        labelText: "Confirm new Password",
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
                        }

                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    Text(
                      message ?? "",
                      style: const TextStyle(color: Colors.red),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ButtonCustom(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {}
                                authProvider.confirmResetPassword(
                                  context,
                                  int.parse(pinController.text),
                                  password1Controller.text,
                                  password2Controller.text,
                                );
                              },
                              isLoading: authProvider.isLoading,
                              child: const Text("Submit"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
