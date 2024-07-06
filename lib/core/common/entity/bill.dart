import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';

enum BillStatus {
  Reviewing,
  Approved,
  Rejected
}

class Bill {
  final Invoice invoice;
  final String billId;
  final BillStatus status;
  final double paidAmount;
  final double pendingAmount;
  final String authorName;
  final String authorPic;

  Bill({
    required this.invoice,
    required this.billId,
    required this.status,
    required this.paidAmount,
    required this.pendingAmount,
    required this.authorName,
    required this.authorPic,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      invoice: Invoice.fromJson(json['invoice']),
      billId: json['billId'],
      status: BillStatus.values.firstWhere((e) => e.toString() == 'BillStatus.${json['status']}'),
      paidAmount: json['paidAmount'],
      pendingAmount: json['pendingAmount'],
      authorName: json['authorName'],
      authorPic: json['authorPic'],
    );
  }

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

  Bill updateInvoiceBill(Invoice newInvoice) {
    return Bill(
      invoice: newInvoice,
      billId: this.billId,
      status: this.status,
      paidAmount: this.paidAmount,
      pendingAmount: this.pendingAmount,
      authorName: this.authorName,
      authorPic: this.authorPic,
    );
  }

}

String billStatusToString(BillStatus status) {
  return status.toString().split('.').last;
}

BillStatus stringToBillStatus(String status) {
  return BillStatus.values.firstWhere((e) => e.toString() == 'BillStatus.$status');
}
