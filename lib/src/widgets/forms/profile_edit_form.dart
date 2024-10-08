import 'package:flutter/material.dart';
import 'package:library_app/src/widgets/ui/button_custom.dart';
import 'package:provider/provider.dart';

import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/models/user.dart';

class ProfileEditForm extends StatefulWidget {
  final User? user;
  const ProfileEditForm({super.key, this.user});

  @override
  _ProfileEditForm createState() => _ProfileEditForm();
}

class _ProfileEditForm extends State<ProfileEditForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameControler = TextEditingController();
  final emailControler = TextEditingController();
  final firstNameControler = TextEditingController();
  final lastNameControler = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameControler.dispose();
    emailControler.dispose();
    firstNameControler.dispose();
    lastNameControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = widget.user;
    usernameControler.text = user?.username ?? "";
    emailControler.text = user?.email ?? "";
    firstNameControler.text = user?.firstName ?? "";
    lastNameControler.text = user?.lastName ?? "";

    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      final message = authProvider.message;
      return Column(
        children: [
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: usernameControler,
                    decoration: const InputDecoration(
                      hintText: "Enter your Username",
                      labelText: "Username",
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailControler,
                    decoration: const InputDecoration(
                      hintText: "Enter your Email",
                      labelText: "Email",
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: firstNameControler,
                    decoration: const InputDecoration(
                      hintText: "Enter your First Name",
                      labelText: "First Name",
                    ),
                  ),
                  TextFormField(
                    controller: lastNameControler,
                    decoration: const InputDecoration(
                      hintText: "Enter your Last Name",
                      labelText: "Last Name",
                    ),
                  ),
                  Text(
                    message ?? "",
                    style: const TextStyle(color: Colors.red),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ButtonCustom(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                          authProvider.updateUserDetail(
                            context,
                            authProvider.user!.id,
                            usernameControler.text,
                            emailControler.text,
                            firstNameControler.text,
                            lastNameControler.text,
                            authProvider.user!.isStaff,
                          );
                        },
                        isLoading: authProvider.isLoading,
                        child: const Text("Submit"),
                      ),
                    ),
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
