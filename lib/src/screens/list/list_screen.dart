import 'package:flutter/material.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/screens/list/admin_list_screen.dart';
import 'package:library_app/src/screens/list/member_list_screen.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    if (user != null && user.isStaff) {
      return const AdminListScreen();
    }

    return const MemberListScreen();
  }
}
