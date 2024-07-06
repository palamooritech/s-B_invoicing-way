import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';

class UserAccountModel extends UserAccount{
  UserAccountModel({
    required super.id,
    required super.emailId,
    required super.name,
    required super.designation,
    required super.profilePicUrl,
    required super.invoiceCount
  });

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return UserAccountModel(
      id: json['id'],
      emailId: json['emailId'],
      name: json['name'],
      designation: json['designation'],
      profilePicUrl: json['profilePicUrl'],
      invoiceCount: json['invoiceCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emailId': emailId,
      'name': name,
      'designation': designation,
      'profilePicUrl': profilePicUrl,
      'invoiceCount': invoiceCount,
    };
  }

  UserAccount toUserAccount() {
    return UserAccount(
      id: id,
      emailId: emailId,
      name: name,
      designation: designation,
      profilePicUrl: profilePicUrl,
      invoiceCount: invoiceCount,
    );
  }

  factory UserAccountModel.fromUserAccount(UserAccount userAccount) {
    return UserAccountModel(
      id: userAccount.id,
      emailId: userAccount.emailId,
      name: userAccount.name,
      designation: userAccount.designation,
      profilePicUrl: userAccount.profilePicUrl,
      invoiceCount: userAccount.invoiceCount,
    );
  }

}