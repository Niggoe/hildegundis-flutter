import 'package:flutter/material.dart';
import 'package:hildegundis_app/blocs/FormationUIBloc.dart';

class FormationUIBlocProvider extends InheritedWidget {
  final bloc = FormationUIBloc();

  FormationUIBlocProvider({Key key, Widget child})
      : super(key: key, child: child);
  bool updateShouldNotify(_) => true;

  static FormationUIBloc of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<FormationUIBlocProvider>())
        .bloc;
  }
}
