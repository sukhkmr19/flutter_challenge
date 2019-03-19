import 'dart:async';

import 'package:flutter_app_challenge/actions/ActionEvents.dart';

class ActionBloc {
  bool _isLongPress = false;
  int _itemPos = -1;

  final _deleteEventStateController = StreamController<int>();

  final _longPressEventStateController = StreamController<bool>();

  StreamSink<int> get _inActions => _deleteEventStateController.sink;

  StreamSink<bool> get _inActionsLongPress =>
      _longPressEventStateController.sink;

  // For state, exposing only a stream which outputs data
  Stream<int> get delete => _deleteEventStateController.stream;

  Stream<bool> get longPress => _longPressEventStateController.stream;

  final _actionEventsController = StreamController<ActionEvents>();

  // For events, exposing only a sink which is an input
  Sink<ActionEvents> get deleteEventSink => _actionEventsController.sink;

  Sink<ActionEvents> get longPressEventSink => _actionEventsController.sink;

  eventsBloc() {
    // Whenever there is a new event, we want to map it to a new state
    _actionEventsController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ActionEvents event) {
    if (event is DeleteActionEvent) {
      _inActions.add(_itemPos);
    } else {
      _inActionsLongPress.add(!_isLongPress);
    }
  }

  void dispose() {
    _deleteEventStateController.close();
    _actionEventsController.close();
    _longPressEventStateController.close();
  }
}
