import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/utils/loader.dart';
import 'package:invoicing_sandb_way/core/utils/show_snack_bar.dart';
import 'package:invoicing_sandb_way/features/bill/presentation/bloc/bill_bloc.dart';
import 'package:invoicing_sandb_way/features/bill/presentation/pages/view_invoice_details_page.dart';
import 'package:invoicing_sandb_way/features/bill/presentation/widgets/custom_card.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {

  @override
  void initState() {
    super.initState();
    context.read<BillBloc>().add(BillFetchBillsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BillBloc,BillState>(
        listener: (context,state){
          if(state is BillFailureState){
            showSnackBar(context, state.error);
          }
        },
        builder: (context,state){
          if(state is BillFailureState){
            return const Loader();
          }
          if(state is BillFetchBillSuccessState){
            return RefreshIndicator(
              onRefresh: ()async{
                context.read<BillBloc>().add(BillFetchBillsEvent());
            },
              child: ListView.builder(
                itemCount: state.bills.length+1,
                  itemBuilder: (context,index) {
                    if (index < state.bills.length) {
                      final bill = state.bills[index];
                      return CustomCard(
                          title: bill.invoice.title,
                          totalAmount: bill.pendingAmount,
                          date: DateFormat('yyyy-MM-dd').format(
                              bill.invoice.updatedAt),
                          status: billStatusToString(bill.status),
                          userName: bill.authorName,
                          userPicUrl: bill.authorPic,
                          buttonText: "View Details",
                          onButtonPressed: () {
                            Navigator.push(context,ViewInvoiceDetailsPage.route(bill));
                          }
                      );
                    }else{
                      return const SizedBox(height: 100,);
                    }
                  }
              ),
            );
          }
          return const Loader();
        },
      )
    );
  }
}
