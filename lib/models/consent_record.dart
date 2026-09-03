class ConsentRecord {
  final String id;
  final String action;
  final String description;
  final DateTime timestamp;
  final String status;

  const ConsentRecord({
    required this.id,
    required this.action,
    required this.description,
    required this.timestamp,
    required this.status,
  });
}
