import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:library_app/src/widgets/forms/login_form.dart';
import 'package:library_app/src/widgets/forms/reset_password_form.dart';
import 'package:library_app/src/widgets/forms/sign_up_form.dart';

class FormScreen extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? action;
  final bool? withBackButton;
  final String? backRoute;

  const FormScreen({
    super.key,
    required this.title,
    required this.body,
    this.backRoute,
    this.action,
    this.withBackButton,
  });

  @override
  State<FormScreen> createState() => _FormScreen();
}

class _FormScreen extends State<FormScreen> {
  String get title => widget.title;
  Widget get body => widget.body;
  List<Widget>? get action => widget.action;
  bool? get withBackButton => widget.withBackButton;
  String? get backRoute => widget.backRoute;

  @override
  Widget build(BuildContext context) {
    final bool withBack = withBackButton != null ? withBackButton! : true;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: withBack
            ? BackButton(
                onPressed: () => context.push(backRoute ?? ""),
              )
            : null,
        actions: action,
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: body,
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "Login";

    return FormScreen(
      withBackButton: false,
      title: title,
      body: const LoginForm(),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "Sign Up";

    return FormScreen(
      title: title,
      backRoute: "/",
      body: const SignUpForm(),
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "Reset Password";

    return FormScreen(
      title: title,
      backRoute: "/",
      body: const ResetPasswordForm(),
    );
  }
}

class ConfirmResetPasswordScreen extends StatelessWidget {
  const ConfirmResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "Reset Password";

    return FormScreen(
      title: title,
      withBackButton: false,
      body: const ConfirmResetPasswordForm(),
    );
  }
}
