import 'package:flutter/material.dart';
import 'package:library_app/src/models/book.dart';
import 'package:library_app/src/models/user.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:library_app/src/models/loan.dart';
import 'package:library_app/src/widgets/loans/loan_item.dart';

class AdminLoanList extends StatefulWidget {
  final String title;
  final String type;

  const AdminLoanList({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<AdminLoanList> createState() => _AdminLoanList();
}

class _AdminLoanList extends State<AdminLoanList> {
  String get title => widget.title;
  String get type => widget.type;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<AuthProvider>(context, listen: false).getLoans(type);
      },
    );
    super.initState();
  }

  ScrollController listScrollController = ScrollController();
  void scrollToTop() {
    if (listScrollController.hasClients) {
      final position = listScrollController.position.minScrollExtent;
      listScrollController.jumpTo(position);
    }
  }

  Future<void> nextPage() async {
    if (Provider.of<AuthProvider>(context, listen: false).hasNextPage) {
      Provider.of<AuthProvider>(context, listen: false).setPage(
        Provider.of<AuthProvider>(context, listen: false).pageNumber + 1,
      );
    } else {
      Provider.of<AuthProvider>(context, listen: false).setPage(
          Provider.of<AuthProvider>(context, listen: false).totalPages!);
    }
    Provider.of<AuthProvider>(context, listen: false).getMemberLoan();
    scrollToTop();
  }

  Future<void> prevPage() async {
    if (Provider.of<AuthProvider>(context, listen: false).hasPrevPage) {
      Provider.of<AuthProvider>(context, listen: false).setPage(
        Provider.of<AuthProvider>(context, listen: false).pageNumber - 1,
      );
    } else {
      Provider.of<AuthProvider>(context, listen: false).setPage(1);
    }

    Provider.of<AuthProvider>(context, listen: false).getMemberLoan();
    scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, loanProvider, child) {
      final getLoans = type == "upcoming"
          ? loanProvider.nearOutstandingLoans
          : loanProvider.overduedLoans;
      if (getLoans != null) {
        var loans = getLoans.map(
          (loan) {
            var book = Book.fromJson(loan["book"]);
            var user = User.fromJson(loan["user"]);

            return Loan(
              book,
              user,
              loan["loan_date"],
              loan["due_date"],
              loan["remaining_loan_time"],
              loan["is_overdue"],
            );
          },
        );

        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [TopAppBar(title: title)];
          },
          body: ListView.builder(
            controller: listScrollController,
            itemCount: loans.length + 1,
            itemBuilder: (context, index) {
              if (index < loans.length) {
                return LoanItem(
                  loans.elementAt(index),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: prevPage,
                        child: const Text('Prev'),
                      ),
                      Text(loanProvider.pageNumber.toString()),
                      ElevatedButton(
                        onPressed: nextPage,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      } else {
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [TopAppBar(title: title)];
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
