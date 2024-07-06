part of 'user_account_bloc.dart';

@immutable
sealed class UserAccountEvent{}

final class UserAccountPutUpdate extends UserAccountEvent{
  final UserAccount userAccount;
  UserAccountPutUpdate(this.userAccount);
}

final class UserAccountGetStatus extends UserAccountEvent{
  final String id;
  UserAccountGetStatus(this.id);
}

final class UserAccountGetAccount extends UserAccountEvent{
  final String id;
  UserAccountGetAccount(this.id);
}

final class UserAccountUploadImage extends UserAccountEvent{
  final String filePath;
  final String uid;
  UserAccountUploadImage(this.filePath, this.uid);
}