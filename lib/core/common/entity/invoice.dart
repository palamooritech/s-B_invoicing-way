class Invoice {
  final String id;
  final String authorId;
  final String title;
  final String description;
  final DateTime startData;
  final DateTime endDate;
  final List<InvoiceEntry> entries;
  final String status;
  final DateTime updatedAt;
  final String comments;

  Invoice({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.startData,
    required this.endDate,
    required this.entries,
    required this.status,
    required this.updatedAt,
    required this.comments
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    var entriesList = json['entries'] as List<dynamic>;
    List<InvoiceEntry> entries =
    entriesList.map((entry) => InvoiceEntry.fromJson(entry)).toList();

    return Invoice(
      id: json['id'],
      authorId: json['authorId'],
      title: json['title'],
      description: json['description'],
      startData: DateTime.parse(json['startData']),
      endDate: DateTime.parse(json['endDate']),
      entries: entries,
      status: json['status'],
      comments: json['comments'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> entriesJson =
    entries.map((entry) => entry.toJson()).toList();

    return {
      'id': id,
      'authorId': authorId,
      'title': title,
      'description': description,
      'startData': startData.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'entries': entriesJson,
      'status': status,
      'comments':comments,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

}

class InvoiceEntry {
  final String description;
  final int rate;
  final int kms;

  InvoiceEntry({
    required this.description,
    required this.rate,
    required this.kms,
  });

  factory InvoiceEntry.fromJson(Map<String, dynamic> json) {
    return InvoiceEntry(
      description: json['description'],
      rate: json['rate'] as int,
      kms: json['kms'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'rate': rate,
      'kms': kms,
    };
  }
}
