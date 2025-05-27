import 'dart:async';

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({
    this.duration = const Duration(milliseconds: 500),
  });

  void run(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
