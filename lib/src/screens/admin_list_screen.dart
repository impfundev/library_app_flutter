import 'package:flutter/material.dart';
import 'package:library_app/src/widgets/loans/admin_loan_list.dart';
import 'package:provider/provider.dart';

import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/providers/book_provider.dart';
import 'package:library_app/src/providers/navigations_provider.dart';

import 'package:library_app/src/widgets/home.dart';
import 'package:library_app/src/widgets/profile.dart';

class AdminListScreen extends StatefulWidget {
  const AdminListScreen({super.key});

  @override
  State<AdminListScreen> createState() => _AdminListScreen();
}

class _AdminListScreen extends State<AdminListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationsProvider, AuthProvider>(
      builder: (context, navProvider, authProvider, child) {
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              navProvider.navigate(index);
            },
            selectedIndex: navProvider.currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
                tooltip: 'Home Page',
              ),
              NavigationDestination(
                icon: Icon(Icons.timer_outlined),
                label: 'Upcoming',
                tooltip: 'Book List',
              ),
              NavigationDestination(
                icon: Icon(Icons.timer_off_rounded),
                label: 'Overdued',
                tooltip: 'Loan List',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_2_sharp),
                label: 'Profile',
                tooltip: 'Profile',
              ),
            ],
          ),
          body: <Widget>[
            // Home
            const HomePage(),
            // Near Outstanding Loans
            const AdminLoanList(
                title: "Near Outstanding Loans", type: "upcoming"),
            // Overdued Loans
            const AdminLoanList(title: "Overdued Loans", type: "overdue"),
            // Profile
            const Profile(),
          ][navProvider.currentPageIndex],
        );
      },
    );
  }
}
