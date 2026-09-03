import 'package:flutter/material.dart';
import '../models/consent_record.dart';

class ConsentProvider extends ChangeNotifier {
  final List<ConsentRecord> _records = [];

  List<ConsentRecord> get records =>
      List.unmodifiable(_records.reversed.toList());

  void record({
    required String action,
    required String description,
    String status = 'Recorded',
  }) {
    _records.add(ConsentRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      action: action,
      description: description,
      timestamp: DateTime.now(),
      status: status,
    ));
    notifyListeners();
  }

  void clear() {
    _records.clear();
    notifyListeners();
  }
}
