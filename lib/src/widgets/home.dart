import 'package:flutter/material.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/providers/navigations_provider.dart';

import 'package:library_app/src/widgets/card_shortcut.dart';
import 'package:library_app/src/widgets/navigations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (context.mounted) {
        Provider.of<AuthProvider>(context, listen: false).getUserDetail();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = "Home";

    return Consumer2<NavigationsProvider, AuthProvider>(
      builder: (context, navProvider, authProvider, child) {
        final user = authProvider.user;
        if (user != null) {
          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const TopBar(title: title),
              ];
            },
            body: ListView(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Shortcut"),
                ),
                Shortcut(
                  icon:
                      user.isStaff ? Icons.timer_outlined : Icons.book_rounded,
                  title: user.isStaff ? "Near Outstanding Loans" : "Books",
                  subtitle: user.isStaff
                      ? "Discover near outstanding users loans."
                      : "Discover many amazing books.",
                  onTap: () {
                    navProvider.navigate(1);
                  },
                ),
                Shortcut(
                  icon: user.isStaff
                      ? Icons.timer_off_rounded
                      : Icons.date_range_rounded,
                  title: user.isStaff ? "Overdued Loans" : "Book Loans",
                  subtitle: user.isStaff
                      ? "Discover Overdued users loans."
                      : "Manage your book loan very easy.",
                  onTap: () {
                    navProvider.navigate(2);
                  },
                ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}
