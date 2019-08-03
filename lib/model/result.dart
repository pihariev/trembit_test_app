import 'package:flutter/foundation.dart';

enum ResultState { SUCCESS, ERROR }

@immutable
class Result<T> {
  final ResultState state;
  final T data;
  final String error;

  Result._(
    this.state, [
    this.data,
    this.error,
  ]);

  factory Result.success(T data) {
    return Result._(ResultState.SUCCESS, data);
  }

  factory Result.error([String error]) {
    return Result._(ResultState.ERROR, null, error);
  }
}
