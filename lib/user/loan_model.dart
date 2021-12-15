class LoanModel {
  String? user;
  String? isbn;
  String title = "N/A";
  String? from;
  String? to;

  /// Creates a new Loan object.
  /// Takes dates in the form of Strings formatted as d.m.yyyy
  LoanModel(String email, String title, String isbn, String from, String to) {
    this.user = email;
    this.title = title;
    this.isbn = isbn;
    this.from = from;
    this.to = to;
  }
}
