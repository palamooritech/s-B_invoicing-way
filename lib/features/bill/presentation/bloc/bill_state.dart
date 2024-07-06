part of 'bill_bloc.dart';

@immutable
sealed class BillState{}

final class BillInitialState extends BillState{}

final class BillLoadingState extends BillState{}

final class BillUpdateSuccessState extends BillState{}

final class BillFetchBillSuccessState extends BillState{
  final List<Bill> bills;
  BillFetchBillSuccessState(this.bills);
}

final class BillDeleteSuccessState extends BillState{}

final class BillApproveSuccessState extends BillState{}

final class BillRejectSuccessState extends BillState{}

final class BillFailureState extends BillState{
  final String error;
  BillFailureState(this.error);
}