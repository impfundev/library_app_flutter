import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoanBookForm extends StatefulWidget {
  final int bookId;
  const LoanBookForm({super.key, required this.bookId});

  @override
  State<LoanBookForm> createState() => _LoanBookForm();
}

class _LoanBookForm extends State<LoanBookForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final loanDayController = TextEditingController();

  @override
  void dispose() {
    loanDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: FilledButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Borrow for how many days?',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  content: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: loanDayController,
                      decoration: const InputDecoration(
                        hintText: "Input day in number",
                        labelText: "Days",
                        suffixIcon: Icon(Icons.date_range),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        authProvider.createMemberLoan(
                          authProvider.user!.accountId,
                          widget.bookId,
                          int.parse(loanDayController.text),
                        );
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('borrow'),
        ),
      );
    });
  }
}
