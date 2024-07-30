import 'package:flutter/material.dart';
import 'package:library_app/src/providers/book_provider.dart';

import 'package:library_app/src/widgets/books/book_item.dart';
import 'package:library_app/src/models/book.dart';
import 'package:library_app/src/widgets/forms/search_form.dart';
import 'package:provider/provider.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookList();
}

class _BookList extends State<BookList> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false).getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        if (bookProvider.books != null) {
          final Iterable<Book> books = bookProvider.books!.map(
            (book) => Book(
              book["id"],
              book["title"],
              book["author"],
              book["description"],
              book["cover_image"],
              book["category"],
            ),
          );

          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [const TopAppBar(title: "Books")];
            },
            body: ListView(
              children: List.generate(books.length, (index) {
                return BookItem(
                  books.elementAt(index),
                );
              }),
            ),
          );
        } else {
          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [const TopAppBar(title: "Books")];
            },
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class TopAppBar extends StatefulWidget {
  final String title;

  const TopAppBar({super.key, required this.title});

  @override
  _TopAppBar createState() => _TopAppBar();
}

class _TopAppBar extends State<TopAppBar> {
  String get title => widget.title;
  bool showWidget = false;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(showWidget ? "" : title),
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  showWidget = !showWidget;
                });
              },
              icon: Icon(showWidget ? Icons.close : Icons.search),
            ),
            Offstage(
              offstage: !showWidget,
              child: const SearchForm(),
            ),
          ],
        ),
      ],
      elevation: 10.0,
      automaticallyImplyLeading: false,
      expandedHeight: 50,
      floating: true,
      snap: true,
    );
  }
}
