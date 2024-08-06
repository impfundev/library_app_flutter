import 'package:flutter/material.dart';
import 'package:library_app/src/models/category.dart';
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
  void dispose() {
    super.dispose();
  }

  ScrollController listScrollController = ScrollController();
  void scrollToTop() {
    if (listScrollController.hasClients) {
      final position = listScrollController.position.minScrollExtent;
      listScrollController.jumpTo(position);
    }
  }

  Future<void> nextPage() async {
    if (Provider.of<BookProvider>(context, listen: false).hasNextPage) {
      Provider.of<BookProvider>(context, listen: false).setPage(
        Provider.of<BookProvider>(context, listen: false).pageNumber + 1,
      );
    } else {
      Provider.of<BookProvider>(context, listen: false).setPage(
          Provider.of<BookProvider>(context, listen: false).totalPages!);
    }
    Provider.of<BookProvider>(context, listen: false).getBooks();
    scrollToTop();
  }

  Future<void> prevPage() async {
    if (Provider.of<BookProvider>(context, listen: false).hasPrevPage) {
      Provider.of<BookProvider>(context, listen: false).setPage(
        Provider.of<BookProvider>(context, listen: false).pageNumber - 1,
      );
    } else {
      Provider.of<BookProvider>(context, listen: false).setPage(1);
    }

    Provider.of<BookProvider>(context, listen: false).getBooks();
    scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final Iterable<Book> books = bookProvider.books!.map((book) {
          if (book["category"] != null) {
            final Category category = Category.fromJson(
              book["category"],
            );
            return Book(
              book["id"],
              book["title"],
              book["author"],
              book["description"],
              book["cover_image"],
              category.name,
            );
          }

          return Book(
            book["id"],
            book["title"],
            book["author"],
            book["description"],
            book["cover_image"],
            null,
          );
        });

        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [const TopAppBar(title: "Books")];
          },
          body: ListView.builder(
            controller: listScrollController,
            itemCount: books.length + 1,
            itemBuilder: (context, index) {
              if (index < books.length) {
                return BookItem(books.elementAt(index));
              } else {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: prevPage,
                        child: const Text('Prev'),
                      ),
                      Text(bookProvider.pageNumber.toString()),
                      ElevatedButton(
                        onPressed: nextPage,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
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
    return Consumer<BookProvider>(builder: (context, bookProvider, child) {
      final category = bookProvider.filterByCategory;
      final appBarTitle = category != null ? "$category $title" : title;

      return SliverAppBar(
        title: Text(showWidget ? "" : appBarTitle),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    showWidget = !showWidget;
                    if (!showWidget) {
                      bookProvider.setSearchKeyword(null);
                      bookProvider.getBooks();
                    }
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
        leading: !showWidget
            ? IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
              )
            : null,
        elevation: 10.0,
        automaticallyImplyLeading: false,
        expandedHeight: 50,
        floating: true,
        snap: true,
      );
    });
  }
}
