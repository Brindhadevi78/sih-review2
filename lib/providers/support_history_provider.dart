import 'package:flutter/material.dart';

class SupportChoice {
  final String label;
  final DateTime chosenAt;
  const SupportChoice({required this.label, required this.chosenAt});
}

class SupportHistoryProvider extends ChangeNotifier {
  final List<SupportChoice> _choices = [];

  List<SupportChoice> get choices =>
      List.unmodifiable(_choices.reversed.toList());

  void record(String label) {
    _choices.add(SupportChoice(label: label, chosenAt: DateTime.now()));
    notifyListeners();
  }

  void clear() {
    _choices.clear();
    notifyListeners();
  }
}
