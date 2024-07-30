import 'package:flutter/material.dart';
import 'package:library_app/src/providers/navigations_provider.dart';

import 'package:library_app/src/widgets/card_shortcut.dart';
import 'package:library_app/src/widgets/navigations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const title = "Home";

    return Consumer<NavigationsProvider>(
      builder: (context, navProvider, child) {
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const TopBar(title: title),
            ];
          },
          body: ListView(
            children: <Widget>[
              Shortcut(
                icon: Icons.book_rounded,
                title: "Books",
                subtitle: "Discover many amazing books.",
                onTap: () {
                  navProvider.navigate(1);
                },
              ),
              Shortcut(
                icon: Icons.category_rounded,
                title: "Categories",
                subtitle: "Find the book by category.",
                onTap: () {},
              ),
              Shortcut(
                icon: Icons.date_range_rounded,
                title: "Book Loans",
                subtitle: "Manage your book loan very easy.",
                onTap: () {
                  navProvider.navigate(2);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
