// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';

class Favour extends ChangeNotifier {
  String isFavour = "";
  bool isChoose = false;
  void changeFavour(String Favour, bool isChoose) {
    this.isFavour = Favour;
    this.isChoose = isChoose;
    print("Quynh => ${Favour.toString()}");
    notifyListeners();
  }
}
