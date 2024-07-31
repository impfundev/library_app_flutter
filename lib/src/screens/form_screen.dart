import 'package:flutter/material.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/widgets/forms/admin_login_form.dart';

import 'package:library_app/src/widgets/forms/login_form.dart';
import 'package:library_app/src/widgets/forms/profile_edit_form.dart';
import 'package:library_app/src/widgets/forms/reset_password_form.dart';
import 'package:library_app/src/widgets/forms/sign_up_form.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? action;
  final bool? withBackButton;

  const FormScreen({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.withBackButton,
  });

  @override
  Widget build(BuildContext context) {
    final bool withBack = withBackButton != null ? withBackButton! : true;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: withBack ? const BackButton() : null,
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
      action: [
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AdminLoginScreen(),
              ));
            },
            icon: const Icon(Icons.admin_panel_settings_rounded))
      ],
      body: const LoginForm(),
    );
  }
}

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "Admin Login";

    return FormScreen(
      title: title,
      body: const AdminLoginForm(),
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
      body: const ConfirmResetPasswordForm(),
    );
  }
}

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String title = "Edit Profile";

    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return FormScreen(
        title: title,
        body: ProfileEditForm(user: authProvider.user),
      );
    });
  }
}
