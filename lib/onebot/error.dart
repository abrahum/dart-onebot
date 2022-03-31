import 'action.dart';

class MissFieldError extends Error {
  final String field;
  MissFieldError(this.field);
  @override
  String toString() => 'MissFieldError: $field';
}

class CallActionTimeout extends Error {
  final Action action;
  CallActionTimeout(this.action);
  @override
  String toString() => 'CallActionTimeOut: $action';
}
