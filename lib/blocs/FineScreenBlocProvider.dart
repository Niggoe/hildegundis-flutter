import 'package:flutter/material.dart';
import 'package:hildegundis_app/blocs/FineScreenBloc.dart';

class FineScreenBlocProvider extends InheritedWidget {
  final bloc = FineScreenBloc();

  FineScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);
  bool updateShouldNotify(_) => true;

  static FineScreenBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(FineScreenBlocProvider)
            as FineScreenBlocProvider)
        .bloc;
  }
}
