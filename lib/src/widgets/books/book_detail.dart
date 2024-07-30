import 'package:flutter/material.dart';

import 'package:library_app/src/models/book.dart';
import 'package:library_app/src/screens/detail_screen.dart';

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
    final screenSize = MediaQuery.of(context).size;

    return DetailScreen(
      title: book.title,
      confirmMessage: "Loans for how many days?",
      textSubmitButton: "Borrow",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.network(
              book.coverUrl ?? "",
              height: screenSize.height * 0.4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              book.title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            'By ${book.author}',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            book.category ?? "",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              book.description,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        ],
      ),
    );
  }
}
