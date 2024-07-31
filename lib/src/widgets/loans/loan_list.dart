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
    Provider.of<AuthProvider>(context, listen: false).getMemberLoan();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      if (authProvider.memberLoans != null) {
        var loans = authProvider.memberLoans!.map(
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
    return Consumer<AuthProvider>(builder: (context, authBuilder, child) {
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
                icon: Icon(
                  showWidget ? Icons.close : Icons.filter_alt_outlined,
                ),
              ),
              Offstage(
                offstage: !showWidget,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [Text("Upcoming"), SwitchToUpcoming()],
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Row(
                      children: [Text("Overdue"), SwitchToOverdued()],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
        elevation: 10.0,
        automaticallyImplyLeading: false,
        expandedHeight: 50,
        floating: true,
        snap: true,
      );
    });
  }
}

class SwitchToUpcoming extends StatefulWidget {
  const SwitchToUpcoming({super.key});

  @override
  State<SwitchToUpcoming> createState() => _SwitchToUpcoming();
}

class _SwitchToUpcoming extends State<SwitchToUpcoming> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Switch(
        value: authProvider.filterByUpcoming,
        onChanged: (bool value) {
          setState(() {
            authProvider.setFilterUpcoming();
            if (authProvider.filterByUpcoming &&
                authProvider.filterByOverdued) {
              authProvider.setFilterOverdued();
            }
            authProvider.getMemberLoan();
          });
        },
      );
    });
  }
}

class SwitchToOverdued extends StatefulWidget {
  const SwitchToOverdued({super.key});

  @override
  State<SwitchToOverdued> createState() => _SwitchToOverdued();
}

class _SwitchToOverdued extends State<SwitchToOverdued> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Switch(
          value: authProvider.filterByOverdued,
          onChanged: (bool value) {
            setState(() {
              authProvider.setFilterOverdued();
              if (authProvider.filterByUpcoming &&
                  authProvider.filterByOverdued) {
                authProvider.setFilterUpcoming();
              }
              authProvider.getMemberLoan();
            });
          },
        );
      },
    );
  }
}
