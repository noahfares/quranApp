/// The outcome of an operation that can fail in an expected way.
///
/// `domain/` returns this instead of throwing for expected failures — see
/// docs/03-conventions.md §4. Exceptions remain reserved for programmer
/// error; `data/` translates plugin and platform exceptions into a
/// domain-level [Err] at the boundary.
sealed class Result<T, E> {
  const Result();

  const factory Result.ok(T value) = Ok<T, E>;
  const factory Result.err(E error) = Err<T, E>;

  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  R when<R>({
    required R Function(T value) ok,
    required R Function(E error) err,
  }) => switch (this) {
    Ok<T, E>(:final value) => ok(value),
    Err<T, E>(:final error) => err(error),
  };

  Result<R, E> map<R>(R Function(T value) transform) => switch (this) {
    Ok<T, E>(:final value) => Result.ok(transform(value)),
    Err<T, E>(:final error) => Result.err(error),
  };

  Result<T, R> mapErr<R>(R Function(E error) transform) => switch (this) {
    Ok<T, E>(:final value) => Result.ok(value),
    Err<T, E>(:final error) => Result.err(transform(error)),
  };
}

final class Ok<T, E> extends Result<T, E> {
  const Ok(this.value);
  final T value;
}

final class Err<T, E> extends Result<T, E> {
  const Err(this.error);
  final E error;
}
