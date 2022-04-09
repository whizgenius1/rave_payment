class TransactionError implements Exception {
  final String message;

  TransactionError(this.message);

  @override
  String toString() => message;
}