import 'dart:async';

void Function(Function f) once() {
  bool canExec = true;
  return (callback) {
    if (canExec) {
      callback();
      canExec = false;
    }
  };
}

final timers = <String, Timer>{};

void _cancelTimer(String id) {
  if (!timers.containsKey(id)) return;
  final timer = timers[id]!;
  timer.cancel();
}

void Function(void Function(void Function() cancel) f) every(
    Duration duration, String id) {
  return (callback) {
    _cancelTimer(id);
    final timer = Timer.periodic(duration, (_) {
      callback(() => _cancelTimer(id));
    });
    timers[id] = timer;
  };
}
