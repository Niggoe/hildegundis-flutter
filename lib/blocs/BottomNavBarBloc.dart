import 'dart:async';

import 'package:hildegundis_app/resources/repository.dart';

enum NavBarItem { EVENTS, FINES, FORMATION }

class BottomNavBarBloc {
  final StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.EVENTS;
  final _repository = Repository();
  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.EVENTS);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.FINES);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.FORMATION);
    }
  }

  Future<void> logoutUser() {
    return _repository.logoutUser();
  }

  close() {
    _navBarController?.close();
  }
}
