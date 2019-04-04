import 'package:flutter/material.dart';
import 'package:hildegundis_app/blocs/EventScreenBloc.dart';

class EventScreenBlocProvider extends InheritedWidget {
  final bloc = EventScreenBloc();

  EventScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);
  bool updateShouldNotify(_) => true;

  static EventScreenBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(EventScreenBlocProvider)
            as EventScreenBlocProvider)
        .bloc;
  }
}
