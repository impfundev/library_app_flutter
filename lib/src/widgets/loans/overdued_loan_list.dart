import 'package:flutter/material.dart';
import 'package:library_app/src/models/book.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:library_app/src/models/loan.dart';
import 'package:library_app/src/widgets/loans/loan_item.dart';

class OverduedLoanList extends StatefulWidget {
  const OverduedLoanList({super.key});

  @override
  State<OverduedLoanList> createState() => _OverduedLoanList();
}

class _OverduedLoanList extends State<OverduedLoanList> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).getLoans("overdue");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, loanProvider, child) {
      if (loanProvider.overduedLoans != null) {
        var loans = loanProvider.overduedLoans!.map(
          (loan) {
            var book = Book.fromJson(loan["book_detail"]);
            return Loan(
              book,
              loan["loan_date"],
              loan["due_date"],
              loan["remaining_loan_time"],
              loan["is_overdue"],
            );
          },
        );

        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [const TopAppBar(title: "Overdued Loans")];
          },
          body: ListView(
            children: List.generate(loans.length, (index) {
              return LoanItem(loans.elementAt(index));
            }),
          ),
        );
      } else {
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [const TopAppBar(title: "Book Loans")];
          },
          body: const Center(
            child: Text("the loan is currently empty"),
          ),
        );
      }
    });
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
      title: Text(title),
      elevation: 10.0,
      automaticallyImplyLeading: false,
      expandedHeight: 50,
      floating: true,
      snap: true,
    );
  }
}
