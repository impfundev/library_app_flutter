import 'package:library_app/src/models/book.dart';
import 'package:library_app/src/models/user.dart';

class Loan {
  Book book;
  User? user;
  String loanDate;
  String dueDate;
  String remainingDays;
  bool isOverdue;

  Loan(
    this.book,
    this.user,
    this.loanDate,
    this.dueDate,
    this.remainingDays,
    this.isOverdue,
  );
}
