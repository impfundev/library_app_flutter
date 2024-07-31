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

  factory Loan.fromJson(Map<String, dynamic> data) {
    final book = Book.fromJson(data["book_detail"]);
    return Loan(
      book,
      data["loan_date"],
      data["due_date"],
      data["remaining_loan_time"],
      data["is_overdue"],
    );
  }
}
