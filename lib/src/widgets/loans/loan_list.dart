import 'package:flutter/material.dart';
import 'package:library_app/src/models/book.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:library_app/src/models/loan.dart';
import 'package:library_app/src/widgets/loans/loan_item.dart';

class LoanList extends StatefulWidget {
  final int memberId;
  const LoanList({super.key, required this.memberId});

  @override
  State<LoanList> createState() => _LoanList();
}

class _LoanList extends State<LoanList> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false)
        .getMemberLoan(widget.memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      if (authProvider.memberLoans != null) {
        final Iterable<Loan> loans = authProvider.memberLoans!.map(
          (loan) {
            Map<String, dynamic> bookMap = loan["book_detail"];
            final book = Book.fromJson(bookMap);
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
            return [const TopAppBar(title: "Book Loans")];
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
            child: CircularProgressIndicator(),
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
    final screenSize = MediaQuery.of(context).size;

    return SliverAppBar(
      title: Text(showWidget ? "" : title),
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  showWidget = !showWidget;
                });
              },
              icon: Icon(showWidget ? Icons.close : Icons.filter_alt_outlined),
            ),
            Offstage(
              offstage: !showWidget,
              child: Row(
                children: [
                  FilledButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.04,
                          vertical: screenSize.width * 0.02),
                    ),
                    onPressed: () {},
                    child: const Text('Near Outstanding'),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  FilledButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.04,
                          vertical: screenSize.width * 0.02),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Overdued',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      elevation: 10.0,
      automaticallyImplyLeading: false,
      expandedHeight: 50,
      floating: true,
      snap: true,
    );
  }
}

class LoanTypeFilter extends StatelessWidget implements PreferredSizeWidget {
  final double sizeAppBar = 50.0;

  const LoanTypeFilter({super.key});

  @override
  Size get preferredSize => Size.fromHeight(sizeAppBar);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10.0),
              SizedBox(
                height: 30.0,
                child: OutlinedButton(
                    onPressed: () {}, child: const Text("Near Overdue")),
              ),
              const SizedBox(width: 10.0),
              SizedBox(
                height: 30.0,
                child: OutlinedButton(
                    onPressed: () {}, child: const Text("Overdue")),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
