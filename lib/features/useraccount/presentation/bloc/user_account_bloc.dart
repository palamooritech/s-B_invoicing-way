import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/usecases/get_user_details.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/usecases/status_user_details.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/usecases/update_user_details.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/usecases/upload_user_image.dart';

part 'user_account_event.dart';
part 'user_account_state.dart';

class UserAccountBloc extends Bloc<UserAccountEvent, UserAccountState> {
  final GetUserDetails _getUserDetails;
  final StatusUserDetails _statusUserDetails;
  final UpdateUserDetails _updateUserDetails;
  final UploadUserImage _uploadUserImage;

  UserAccountBloc({
    required GetUserDetails getUserDetails,
    required StatusUserDetails statusUserDetails,
    required UpdateUserDetails updateUserDetails,
    required UploadUserImage uploadUserImage,
  })  : _getUserDetails = getUserDetails,
        _statusUserDetails = statusUserDetails,
        _updateUserDetails = updateUserDetails,
        _uploadUserImage = uploadUserImage,
        super(UserAccountInitial()){
    on<UserAccountEvent>((_,emit)=>emit(UserAccountLoading()));
    on<UserAccountGetStatus>(_onUserAccountGetStatus);
    on<UserAccountPutUpdate>(_onUserAccountPutUpdate);
    on<UserAccountGetAccount>(_onUserAccountGetAccount);
    on<UserAccountUploadImage>(_onUserAccountUploadImage);
  }

  void _onUserAccountGetStatus(UserAccountGetStatus event, Emitter<UserAccountState> emit) async{
    final res = await _statusUserDetails(
        StatusUserDetailsParams(
            id: event.id
        )
    );
    res.fold(
        (err) => emit(UserAccountFailure(err.message)) ,
        (flag) => emit(UserAccountStatusFlag(flag)),
    );
  }

  void _onUserAccountPutUpdate(UserAccountPutUpdate event, Emitter<UserAccountState> emit) async{
    final res = await _updateUserDetails(
        UpdateUserDetailsParams(
            event.userAccount
        )
    );
    res.fold(
          (err) => emit(UserAccountFailure(err.message)) ,
          (flag) => emit(UserAccountUpdateSuccess()),
    );
  }

  void _onUserAccountGetAccount(UserAccountGetAccount event, Emitter<UserAccountState> emit) async{
    final res = await _getUserDetails(
      GetUserDetailsParam(
          id: event.id
      )
    );
    res.fold(
          (err) => emit(UserAccountFailure(err.message)) ,
          (userAccount) => emit(UserAccountDisplaySuccess(userAccount)),
    );
  }

  void _onUserAccountUploadImage(UserAccountUploadImage event, Emitter<UserAccountState> emit) async{
    print("This is called");
    final res = await _uploadUserImage(
        UploadUserImageParams(
            filePath: event.filePath,
            uid: event.uid
        )
    );

    res.fold(
        (err) => emit(UserAccountFailure(err.message)),
        (path) => emit(UserAccountUploadImageSuccess(path)),
    );
  }
}
