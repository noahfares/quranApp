/// Injectable time source. Domain and data code must never call
/// `DateTime.now()` directly — see docs/01-architecture.md §6. A single
/// buried call makes the FSRS scheduler and plan generator untestable at
/// arbitrary dates.
abstract interface class Clock {
  DateTime now();
}

/// The real clock, wired once at the composition root.
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// A settable clock for tests.
class FakeClock implements Clock {
  FakeClock(DateTime initial) : _now = initial;

  DateTime _now;

  @override
  DateTime now() => _now;

  void set(DateTime value) => _now = value;

  void advance(Duration duration) => _now = _now.add(duration);
}
