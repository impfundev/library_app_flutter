import 'package:flutter/material.dart';
import 'package:library_app/src/widgets/forms/book_loan_form.dart';

class DetailScreen extends StatefulWidget {
  final String? textSubmitButton;
  final String title;
  final String confirmMessage;
  final Widget body;

  const DetailScreen({
    super.key,
    required this.title,
    required this.body,
    required this.confirmMessage,
    this.textSubmitButton,
  });

  @override
  _DetailScreen createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final String title = widget.title;
    final Widget body = widget.body;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18.0),
        ),
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: body,
          )
        ],
      ),
      bottomNavigationBar: const LoanBookForm(),
    );
  }
}
