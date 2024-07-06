import 'package:fpdart/src/either.dart';
import 'package:invoicing_sandb_way/core/error/Failure.dart';
import 'package:invoicing_sandb_way/core/usecase/usecase.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/repository/user_account_repository.dart';

class UploadUserImage implements UseCase<String,UploadUserImageParams>{
  final UserAccountRepository userAccountRepository;
  UploadUserImage(this.userAccountRepository);

  @override
  Future<Either<Failure, String>> call(UploadUserImageParams params) async{
    return await userAccountRepository.uploadUserPhoto(
        params.filePath,
        params.uid
    );
  }

}

class UploadUserImageParams{
  final String filePath;
  final String uid;

  UploadUserImageParams({
    required this.filePath,
    required this.uid
  });
}