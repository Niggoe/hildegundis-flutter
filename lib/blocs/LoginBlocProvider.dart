import 'package:flutter/material.dart';
import 'LoginBloc.dart';
export 'LoginBloc.dart';

class LoginBlocProvider extends InheritedWidget {
  final bloc = LoginBloc();

  LoginBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<LoginBlocProvider>()
        .bloc);
  }
}
