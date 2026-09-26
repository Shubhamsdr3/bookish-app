sealed class Result<T> {
  const Result();
}

final class Loading<T> extends Result<T> {
  const Loading();
}

final class Success<T> extends Result<T> {
  final T? data;

  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final Exception? error;

  const Failure(this.error);
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  bool get isLoading => this is Loading<T>;

  T? get data => switch (this) {
        Success(data: final value) => value,
        Failure() => null,
        Loading() => null,
      };

  Exception? get error => switch (this) {
        Success() => null,
        Failure(error: final value) => value,
        Loading() => null,
      };

  R fold<R>({
    required R Function(T? data) onSuccess,
    required R Function(Exception? message) onFailure,
    required R Function() onLoading,
  }) =>
      switch (this) {
        Success(data: final value) => onSuccess(value),
        Failure(error: final message) => onFailure(message),
        Loading() => onLoading(),
      };
}
