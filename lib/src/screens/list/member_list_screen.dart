import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_app/src/models/category.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/providers/book_provider.dart';
import 'package:library_app/src/providers/navigations_provider.dart';

import 'package:library_app/src/widgets/books/book_list.dart';
import 'package:library_app/src/widgets/home.dart';
import 'package:library_app/src/widgets/loans/loan_list.dart';
import 'package:library_app/src/widgets/profile.dart';
import 'package:provider/provider.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreen();
}

class _MemberListScreen extends State<MemberListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<NavigationsProvider, AuthProvider, BookProvider>(
      builder: (context, navProvider, authProvider, bookProvider, child) {
        Iterable<Category>? category;
        if (bookProvider.categories != null) {
          category = bookProvider.categories!.map(
            (data) {
              return Category(data["name"]);
            },
          );
        }

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
              memberId: authProvider.user?.id ?? 0,
            ),
            // Profile
            const Profile(),
          ][navProvider.currentPageIndex],
          drawer: Drawer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        child: const Row(
                          children: [Icon(Icons.arrow_back), Text("Back")],
                        ),
                        onPressed: () {
                          bookProvider.filterBookByCategory(null);
                          bookProvider.getBooks();
                          context.pop();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: category != null ? category.length : 0,
                    itemBuilder: (context, index) {
                      if (category != null) {
                        return ListTile(
                          title: Text(category.elementAt(index).name),
                          onTap: () {
                            bookProvider.filterBookByCategory(
                                category!.elementAt(index).name);
                            bookProvider.getBooks();
                            Navigator.pop(context);
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
