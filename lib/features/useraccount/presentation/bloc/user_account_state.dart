part of 'user_account_bloc.dart';

@immutable
sealed class UserAccountState{}

final class UserAccountInitial extends UserAccountState{}

final class UserAccountLoading extends UserAccountState{}

final class UserAccountFailure extends UserAccountState{
  final String error;
  UserAccountFailure(this.error);
}

final class UserAccountUpdateSuccess extends UserAccountState{}

final class UserAccountStatusFlag extends UserAccountState{
  final bool flag;
  UserAccountStatusFlag(this.flag);
}

final class UserAccountDisplaySuccess extends UserAccountState{
  final UserAccount userAccount;
  UserAccountDisplaySuccess(this.userAccount);
}

final class UserAccountUploadImageSuccess extends UserAccountState{
  final String imgPath;
  UserAccountUploadImageSuccess(this.imgPath);
}