import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoanBookForm extends StatelessWidget {
  const LoanBookForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: FilledButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Loans for how many days?'),
                content: Form(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Input number",
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
                  ElevatedButton(
                    onPressed: () {
                      // Submit form data
                      Navigator.of(context).pop();
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
  }
}
