import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';

// Assuming you have Invoice and InvoiceEntry entities already defined in your domain layer
class InvoiceModel extends Invoice {
  InvoiceModel({
    required String id,
    required String authorId,
    required String title,
    required String description,
    required DateTime startData,
    required DateTime endDate,
    required List<InvoiceEntryModel> entries,
    required DateTime updatedAt,
    required String status,
    required String comments
  }) : super(
    id: id,
    authorId: authorId,
    title: title,
    description: description,
    startData: startData,
    endDate: endDate,
    entries: entries,
    updatedAt: updatedAt,
    status: status,
    comments: comments,
  );

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      authorId: json['authorId'],
      title: json['title'],
      description: json['description'],
      startData: DateTime.parse(json['startData']),
      endDate: DateTime.parse(json['endDate']),
      entries: (json['entries'] as List)
          .map((e) => InvoiceEntryModel.fromJson(e))
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'title': title,
      'description': description,
      'startData': startData.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'entries': entries.map((e) => (e as InvoiceEntryModel).toJson()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status,
      'comments':comments,
    };
  }
}

class InvoiceEntryModel extends InvoiceEntry {
  InvoiceEntryModel({
    required String description,
    required int   rate,
    required int kms,
  }) : super(
    description: description,
    rate: rate,
    kms: kms,
  );

  factory InvoiceEntryModel.fromJson(Map<String, dynamic> json) {
    return InvoiceEntryModel(
      description: json['description'],
      rate: json['rate'],
      kms: json['kms'],
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
