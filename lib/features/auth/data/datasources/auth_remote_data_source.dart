import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';
import 'package:invoicing_sandb_way/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class AuthRemoteDataSource{
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDataSourceImpl(this.firebaseAuth, this.firebaseFirestore);
  
  @override
  Future<UserModel?> getCurrentUser() async{
    try{
      final User? user = firebaseAuth.currentUser;
      if(user!=null){
        return userModelGen(user);
      }
      return null;
    }catch(e){
      throw ServerException('Error in Current User ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithEmailPassword({required String email, required String password}) async{
    try{
      final res= await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(res.user == null){
        throw ServerException("User is Null");
      }else{
        return userModelGen(res.user!);
      }
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({required String email, required String password, required String name}) async{
    try{
      final res= await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      final user = res.user;
      if(user != null){
        await user.updateProfile(displayName: name);
        // await firebaseFirestore.collection('users').doc(user.uid).set(
        //     UserAccount(
        //         id: user.uid,
        //         emailId: email,
        //         name: name,
        //         designation: "Guest",
        //         profilePicUrl: "",
        //         invoiceCount: 0
        //     ).toJson()
        // );
        return userModelGen(user);
      }else{
        throw ServerException("User is Null!");
      }
    }catch (e){
      throw ServerException(e.toString());
    }
  }

  UserModel userModelGen(User user) {
    return UserModel(
        name: user!.displayName ?? '',
        email: user!.email ?? '',
        id: user!.uid
    );
  }
}