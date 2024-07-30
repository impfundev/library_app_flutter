import 'package:flutter/foundation.dart';

class NavigationsProvider with ChangeNotifier {
  int currentPageIndex = 0;

  void navigate(int page) {
    currentPageIndex = page;
    notifyListeners();
  }
}
