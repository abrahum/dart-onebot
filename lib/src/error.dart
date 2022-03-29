class MissFieldError extends Error {
  final String field;
  MissFieldError(this.field);
  @override
  String toString() => 'MissFieldError: $field';
}
