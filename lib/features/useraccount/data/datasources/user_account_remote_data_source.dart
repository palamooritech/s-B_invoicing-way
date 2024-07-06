import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';
import 'package:invoicing_sandb_way/features/useraccount/data/models/user_account_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class UserAccountRemoteDataSource{
  Future<UserAccountModel> getUserAccount(String id);
  Future<bool> updateUserAccount(UserAccountModel userAccountModel);
  Future<bool> isNewUser(String id);
  Future<String> uploadImage(String filePath, String uid);
}

class UserAccountRemoteDataSourceImpl implements UserAccountRemoteDataSource{
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  UserAccountRemoteDataSourceImpl(this.firebaseFirestore, this.firebaseStorage);

  @override
  Future<UserAccountModel> getUserAccount(String id) async{
    try{
      final doc = await firebaseFirestore.collection('users').doc(id).get();
      return UserAccountModel.fromJson(doc.data()!);
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> updateUserAccount(UserAccountModel userAccountModel) async {
    try{
      final doc = await firebaseFirestore.collection('users').doc(userAccountModel.id).get();
      if(doc.exists){
        final docRef = firebaseFirestore.collection('users').doc(userAccountModel.id);
        await docRef.update(userAccountModel.toJson());
      }else{
        await firebaseFirestore.collection('users').doc(userAccountModel.id).set(userAccountModel.toJson());
      }
      return true;
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isNewUser(String id) async {
    try{
      final doc = await firebaseFirestore.collection('users').doc(id).get();
      if(!doc.exists){
        return true;
      }else{
        return false;
      }
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage(String filePath, String uid) async {
    try{
      print("Upload Image is called");
      final Reference storageRef = firebaseStorage.ref().child('user_images/$uid');
      await storageRef.putFile(File(filePath));
      final String picUrl = await storageRef.getDownloadURL();
      print("Pic Url - ${picUrl}");
      return picUrl;
    }catch(e){
      throw ServerException(e.toString());
    }
  }

}