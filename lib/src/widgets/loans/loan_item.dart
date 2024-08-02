import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:library_app/src/models/loan.dart';
import 'package:library_app/src/models/user.dart';

class LoanItem extends StatelessWidget {
  final Loan _loan;
  final User? user;

  const LoanItem(this._loan, {super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final formater = DateFormat.yMMMMd();
    final loanDate = formater.format(DateTime.parse(_loan.loanDate));
    final dueDate = formater.format(DateTime.parse(_loan.dueDate));
    final remainingDays = _loan.remainingDays;
    final isOverdue = _loan.isOverdue;
    final bookTitle = _loan.book.title;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color:
                      !isOverdue ? Theme.of(context).primaryColor : Colors.red,
                ),
                child: Text(
                  !isOverdue ? remainingDays : "Overdued",
                  style: const TextStyle(fontSize: 12.0, color: Colors.white),
                ),
              ),
              Offstage(
                offstage: user == null,
                child: Card(
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    textColor: Colors.white,
                    title: Text(user != null ? user!.username : ""),
                    subtitle: Text(user != null ? user!.email : ""),
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
