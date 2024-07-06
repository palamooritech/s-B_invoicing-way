import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';

abstract interface class HomeRemoteDataSource{
  Future<bool> getUserStatus(String id);
  Future<bool> isUserNew(String id);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource{
  final FirebaseFirestore firebaseFirestore;
  HomeRemoteDataSourceImpl(this.firebaseFirestore);
  
  @override
  Future<bool> getUserStatus(String id) async{
    try{
     final docRef = await firebaseFirestore.collection('users').doc(id).get();
     final userAccount = UserAccount.fromJson(docRef.data()!);
     if(userAccount.designation == "Admin"){
       print('flag retunred is true');
       return true;
     }else{
       print('flag retunred is false');
       return false;
     }
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isUserNew(String id) async{
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
}