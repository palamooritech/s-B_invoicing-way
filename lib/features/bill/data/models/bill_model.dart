import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';

class BillModel extends Bill {
  BillModel({
    required super.invoice,
    required super.billId,
    required super.status,
    required super.paidAmount,
    required super.pendingAmount,
    required super.authorName,
    required super.authorPic,
  });

  // Factory constructor to create a BillModel from a JSON object
  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      invoice: Invoice.fromJson(json['invoice']),
      billId: json['billId'],
      status: BillStatus.values.firstWhere((e) => e.toString() == 'BillStatus.${json['status']}'),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      pendingAmount: (json['pendingAmount'] as num).toDouble(),
      authorName: json['authorName'],
      authorPic: json['authorPic'],
    );
  }

  // Method to convert a BillModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'invoice': invoice.toJson(),
      'billId': billId,
      'status': status.toString().split('.').last,
      'paidAmount': paidAmount,
      'pendingAmount': pendingAmount,
      'authorName': authorName,
      'authorPic': authorPic,
    };
  }

  // Method to create a Bill instance from a BillModel
  Bill toBill() {
    return Bill(
      invoice: invoice,
      billId: billId,
      status: status,
      paidAmount: paidAmount,
      pendingAmount: pendingAmount,
      authorName: authorName,
      authorPic: authorPic,
    );
  }

  // Factory constructor to create a BillModel from a Bill instance
  factory BillModel.fromBill(Bill bill) {
    return BillModel(
      invoice: bill.invoice,
      billId: bill.billId,
      status: bill.status,
      paidAmount: bill.paidAmount,
      pendingAmount: bill.pendingAmount,
      authorName: bill.authorName,
      authorPic: bill.authorPic,
    );
  }
}
