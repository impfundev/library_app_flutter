import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordForm();
}

class _ChangePasswordForm extends State<ChangePasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SvgPicture.asset(
              "assets/images/reset_password_image.svg",
              semanticsLabel: "change password",
              height: screenSize.height * 0.2,
            ),
          ),
          const Text(
            "Change Password",
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
                    controller: oldPasswordController,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      hintText: "Enter your Old Password",
                      labelText: "Old Password",
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
                        return "Please enter your old password";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      hintText: "Enter your New Password",
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
                        return "Please enter your new password";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {}
                            authProvider.changePassword(
                              context,
                              authProvider.user!.accountId,
                              oldPasswordController.text,
                              newPasswordController.text,
                            );
                          },
                          child: authProvider.isLoading
                              ? const Loading()
                              : const Text("Submit"),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => context.pop("/"),
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
