import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/core/error/exceptions.dart';
import 'package:invoicing_sandb_way/features/invoices/data/models/invoice_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class InvoiceRemoteDataSource{
  Future<bool> uploadInvoice(InvoiceModel invoice);
  Future<List<InvoiceModel>> getAllInvoices(String id);
  Future<bool> updateInvoice(InvoiceModel invoice);
  Future<bool> deleteInvoice(String id,String uid);
}

class InvoiceRemoteDataSourceImpl extends InvoiceRemoteDataSource{
  final FirebaseFirestore firebaseFirestore;
  InvoiceRemoteDataSourceImpl(this.firebaseFirestore);

  @override
  Future<List<InvoiceModel>> getAllInvoices(String id) async {
    try {
      DocumentReference userDocRef = firebaseFirestore.collection('billData').doc(id);
      QuerySnapshot snapshot = await userDocRef.collection('invoices').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final invoices = InvoiceModel.fromJson(data);
        // print(doc.data());
        // return InvoiceModel(id: "", authorId: "", title: "", description: "", startData: DateTime.now(), endDate: DateTime.now(), entries: [], updatedAt: DateTime.now()) ;
        return invoices;
      }).toList();
    } on FirebaseException catch (e) {
      print('Error in Fetch FF - ${e.toString()}');
      throw ServerException(e.message!);
    } on Exception catch (e) {
      print('Error in Fetch - ${e.toString()}');
      throw ServerException(e.toString());
    } catch (e) {
      print('Unhandled error - ${e.toString()}');
      throw ServerException('An unexpected error occurred.');
    }
  }


  @override
  Future<bool> uploadInvoice(InvoiceModel invoice) async {
    try{
      DocumentReference userDocRef = firebaseFirestore.collection('billData').doc(invoice.authorId);
      await userDocRef.collection('invoices').doc(invoice.id).set(invoice.toJson());
      await billCreator(invoice);
       return true;
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> updateInvoice(InvoiceModel invoice) async{
    try{
      DocumentReference userDocRef = firebaseFirestore.collection('billData').doc(invoice.authorId);
      final docRef = userDocRef.collection('invoices').doc(invoice.id);
      await docRef.update(invoice.toJson());
      final bill = await firebaseFirestore.collection('bills').doc(invoice.id).get();
      final billRef = firebaseFirestore.collection('bills').doc(invoice.id);
      final billM =  Bill.fromJson(bill.data()!);
      final amount = invoice.entries.map((entry) => entry.rate).reduce((
          a, b) => a + b);
      await billRef.update(
          Bill(
              invoice: invoice,
              billId: billM.billId,
              status: BillStatus.Reviewing,
              paidAmount: billM.paidAmount ,
              pendingAmount: amount.toDouble(),
              authorName: billM.authorName,
              authorPic: billM.authorPic,
          ).toJson()
      );
      return true;
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> deleteInvoice(String id, String uid) async{
    try{
      DocumentReference userDocRef = firebaseFirestore.collection('billData').doc(uid);
      final docRef = userDocRef.collection('invoices').doc(id);
      // print(" the doc is - ${docRef}");
      await docRef.delete();
      final billRef = firebaseFirestore.collection('bills').doc(id);
      await billRef.delete();
      return true;
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  Future<void> billCreator(InvoiceModel invoice) async {
    await firebaseFirestore.collection('bills').doc(invoice.id).set(Bill(
        invoice: invoice,
        billId: invoice.id,
        status: BillStatus.Reviewing,
        paidAmount: 0,
        pendingAmount: 0,
        authorName: "",
        authorPic: ""
      ).toJson()
    );
  }

}
