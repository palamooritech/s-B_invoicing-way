import 'package:invoicing_sandb_way/core/common/entity/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User{
  UserModel({
    required super.name,
    required super.id,
    required super.email
  });

  factory UserModel.fromJson(Map<String,dynamic> json) => _$UserModelFromJson(json);
}