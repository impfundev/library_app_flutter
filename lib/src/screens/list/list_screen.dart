import 'package:flutter/material.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/providers/navigations_provider.dart';
import 'package:library_app/src/screens/list/admin_list_screen.dart';
import 'package:library_app/src/screens/list/member_list_screen.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreen();
}

class _ListScreen extends State<ListScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (context.mounted) {
        Provider.of<NavigationsProvider>(context, listen: false).navigate(0);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    if (user != null && user.isStaff) {
      return const AdminListScreen();
    }

    return const MemberListScreen();
  }
}
