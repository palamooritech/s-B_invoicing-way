part of 'bill_bloc.dart';

@immutable
sealed class BillEvent{}

final class BillFetchBillsEvent extends BillEvent{}

final class BillUpdateEvent extends BillEvent{
  final Bill bill;
  BillUpdateEvent(this.bill);
}

final class BillDeleteEvent extends BillEvent{
  final String id;
  BillDeleteEvent(this.id);
}

final class BillApproveEvent extends BillEvent{
  final Bill bill;
  final String comments;
  final double paidAmount;
  BillApproveEvent(this.bill, this.comments, this.paidAmount);
}

final class BillRejectEvent extends BillEvent{
  final Bill bill;
  final String comments;
  final double paidAmount;
  BillRejectEvent(this.bill, this.comments, this.paidAmount);
}