import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/widgets/ui/button_custom.dart';
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
      if (authProvider.loanBookSuccess) {
        final screenSize = MediaQuery.of(context).size;
        return Center(
          child: SizedBox(
            height: screenSize.height * 0.4,
            child: AlertDialog(
              title: const Text(
                'Loan book succed!',
                style: TextStyle(fontSize: 20.0),
              ),
              content: FilledButton(
                onPressed: () {
                  authProvider.setLoanBookSuccess(false);
                  Navigator.of(context).pop();
                },
                child: const Text('Continue'),
              ),
            ),
          ),
        );
      }
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
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Loan day cannot be empty";
                        } else if (value is int) {
                          return "Please enter loan day in number";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ButtonCustom(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                        authProvider.createMemberLoan(
                          authProvider.user!.id,
                          widget.bookId,
                          int.parse(loanDayController.text),
                        );
                        context.pop();
                      },
                      isLoading: authProvider.isLoading,
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
