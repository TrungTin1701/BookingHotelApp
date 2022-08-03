// ignore_for_file: non_constant_identifier_names, file_names, unnecessary_this, avoid_print

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
