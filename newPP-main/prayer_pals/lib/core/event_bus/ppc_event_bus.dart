import 'package:event_bus/event_bus.dart';

class PPCEventBus extends EventBus {
  static final PPCEventBus _singleton = PPCEventBus._internal();

  factory PPCEventBus() {
    return _singleton;
  }

  PPCEventBus._internal();
}
