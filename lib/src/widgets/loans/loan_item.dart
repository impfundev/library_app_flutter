import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:library_app/src/models/loan.dart';

class LoanItem extends StatelessWidget {
  final Loan _loan;

  const LoanItem(this._loan, {super.key});

  @override
  Widget build(BuildContext context) {
    final formater = DateFormat.yMMMMd();
    final loanDate = formater.format(DateTime.parse(_loan.loanDate));
    final dueDate = formater.format(DateTime.parse(_loan.dueDate));
    final remainingDays = _loan.remainingDays;
    final bookTitle = _loan.book.title;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Badge(
                  label: Text(
                    remainingDays,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Book Title",
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bookTitle,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text("Loan Date"),
                    ),
                    Expanded(
                      child: Text(
                        loanDate,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text("Due Date"),
                    ),
                    Expanded(
                      child: Text(
                        dueDate,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
