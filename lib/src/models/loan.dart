import 'package:library_app/src/models/book.dart';

class Loan {
  Book book;
  String loanDate;
  String dueDate;
  String remainingDays;
  bool isOverdue;

  Loan(
    this.book,
    this.loanDate,
    this.dueDate,
    this.remainingDays,
    this.isOverdue,
  );
}
