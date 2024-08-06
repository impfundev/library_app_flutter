import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/widgets/forms/profile_edit_form.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String title = "Edit Profile";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return ListView(children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: ProfileEditForm(user: authProvider.user),
            ),
          ]);
        },
      ),
    );
  }
}
