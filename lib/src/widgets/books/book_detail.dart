import 'package:flutter/material.dart';

import 'package:library_app/src/models/book.dart';
import 'package:library_app/src/screens/detail_screen.dart';
import 'package:library_app/src/widgets/books/book_item.dart';

class BookDetail extends StatefulWidget {
  final Book book;
  const BookDetail({super.key, required this.book});

  @override
  _BookDetail createState() => _BookDetail();
}

class _BookDetail extends State<BookDetail> {
  Book get book => widget.book;

  @override
  Widget build(BuildContext context) {
    return DetailScreen(
      title: book.title,
      confirmMessage: "Loans for how many days?",
      textSubmitButton: "Borrow",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BookItem(book),
          Text(book.description),
        ],
      ),
    );
  }
}
