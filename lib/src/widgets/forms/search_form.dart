import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:library_app/src/providers/book_provider.dart';

class SearchForm extends StatefulWidget implements PreferredSizeWidget {
  final double sizeAppBar = 60.0;
  const SearchForm({super.key});

  @override
  Size get preferredSize => Size.fromHeight(sizeAppBar);

  @override
  _SearchForm createState() => _SearchForm();
}

class _SearchForm extends State<SearchForm> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Container(
      width: queryData.size.width * 0.8,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SearchBar(
        hintText: "Enter keywords...",
        elevation: WidgetStateProperty.all(0),
        onChanged: (value) {
          if (value.length >= 3) {
            Future.delayed(
              Duration.zero,
              () {
                Provider.of<BookProvider>(context, listen: false)
                    .setSearchKeyword(value);
                Provider.of<BookProvider>(context, listen: false).getBooks();
              },
            );
          }
        },
        leading: const Icon(Icons.search),
      ),
    );
  }
}
