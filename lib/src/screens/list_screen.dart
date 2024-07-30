import 'package:flutter/material.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/providers/navigations_provider.dart';

import 'package:library_app/src/widgets/books/book_list.dart';
import 'package:library_app/src/widgets/home.dart';
import 'package:library_app/src/widgets/loans/loan_list.dart';
import 'package:library_app/src/widgets/profile.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

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
                icon: Icon(Icons.book_sharp),
                label: 'Books',
                tooltip: 'Book List',
              ),
              NavigationDestination(
                icon: Icon(Icons.date_range_sharp),
                label: 'Loans',
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
            // Books
            const BookList(),
            // Loans
            LoanList(
              memberId: authProvider.user!.id,
            ),
            // Profile
            const Profile(),
          ][navProvider.currentPageIndex],
        );
      },
    );
  }
}
