import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';
import 'package:invoicing_sandb_way/features/bill/data/models/bill_model.dart';
import 'package:invoicing_sandb_way/features/invoices/data/models/invoice_model.dart';

abstract interface class BillRemoteDataSource{
  Future<List<BillModel>> getAllBills();
  Future<bool> updateBill(BillModel bill);
  Future<bool> deleteBill(String id);
  Future<bool> approveBill(BillModel billModel);
  Future<bool> rejectBill(BillModel billModel);
}

class BillRemoteDataSourceImpl implements BillRemoteDataSource{
  final FirebaseFirestore firebaseFirestore;
  BillRemoteDataSourceImpl(this.firebaseFirestore);

  @override
  Future<bool> deleteBill(String id) async {
    try{
      await firebaseFirestore.collection('bills').doc(id).delete();
      return true;
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  Future<List<BillModel>> getAllBills() async {
    try {
      // Fetch bills from Firestore
      final snapShot = await firebaseFirestore.collection('bills').get();

      // Iterate through each document and process bills
      await Future.forEach(snapShot.docs, (doc) async {
        final bill = BillModel.fromJson(doc.data());

        // Call generateBillContent for each bill
        await generateBillContent(bill);
      });

      // Fetch bills again to return as a list
      final snapSh = await firebaseFirestore.collection('bills').get();
      return snapSh.docs.map((doc) {
        return BillModel.fromJson(doc.data());
      }).toList();

    } catch (e) {
      print('Error - ${e.toString()}');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> updateBill(BillModel bill) async{
    try{
      await firebaseFirestore.collection('bills').doc(bill.billId).update(bill.toJson());
      DocumentReference userDocRef = firebaseFirestore.collection('billData').doc(bill.invoice.authorId);
      final docRef = userDocRef.collection('invoices').doc(bill.invoice.id);
      await docRef.update(bill.invoice.toJson());
      return true;
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> approveBill(BillModel billModel) async{
    try{
      await firebaseFirestore.collection('bills').doc(billModel.billId).update(billModel.toJson());
      DocumentReference userDocRef = firebaseFirestore.collection('billData').doc(billModel.invoice.authorId);
      final docRef = userDocRef.collection('invoices').doc(billModel.invoice.id);
      await docRef.update(billModel.invoice.toJson());
      return true;
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> rejectBill(BillModel billModel) async{
    try{
      await firebaseFirestore.collection('bills').doc(billModel.billId).update(billModel.toJson());
      DocumentReference userDocRef = firebaseFirestore.collection('billData').doc(billModel.invoice.authorId);
      await userDocRef.collection('invoices').doc(billModel.invoice.id).update(billModel.invoice.toJson());
      print("Bill. invoice is ${billModel.invoice}");
      return true;
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  Future<void> generateBillContent(BillModel bill) async {
    if (bill.pendingAmount == 0) {
      try {
        final user = await firebaseFirestore.collection('users').doc(
            bill.invoice.authorId).get();
        final userAccount = UserAccount.fromJson(user.data()!);

        final amount = bill.invoice.entries.map((entry) => entry.rate).reduce((
            a, b) => a + b);

        await firebaseFirestore.collection('bills').doc(bill.billId).update(
          BillModel(
            invoice: bill.invoice,
            billId: bill.billId,
            status: bill.status,
            paidAmount: 0,
            pendingAmount: amount.toDouble(),
            authorName: userAccount.name,
            authorPic: userAccount.profilePicUrl,
          ).toJson(),
        );
      } catch (e) {
        print('Error updating bill: ${e.toString()}');
        throw ServerException(e.toString());
      }
    }
  }
}