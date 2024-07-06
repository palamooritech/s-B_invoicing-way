import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/cubit/appuser/app_user_cubit.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/core/common/entity/user.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';
import 'package:invoicing_sandb_way/core/utils/loader.dart';
import 'package:invoicing_sandb_way/core/utils/show_snack_bar.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/bloc/invoice_bloc.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/pages/add%20invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/pages/edit_invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/widgets/invoice_card.dart';

class InvoicesPage extends StatefulWidget {
  static route()=> MaterialPageRoute(
      builder: (context) => const InvoicesPage()
  );
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  final _outlinedButtonStyle = OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent, // Background color
      side: const BorderSide(color: AppPallete.gradient1, width: 2), // Border color and width
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
  );
  late User user;

  @override
  void initState() {
    super.initState();
    user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    context.read<InvoiceBloc>().add(InvoiceFetchAllInvoices(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, AddNewInvoice.route());
        },
        backgroundColor: AppPallete.gradient1,
        shape: const CircleBorder(),
        child: const Icon(Icons.add,color: Colors.white,),
      ) ,
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(offsetY: 120.0, offsetX: 20.0),
      body: BlocConsumer<InvoiceBloc,InvoiceState>(
        listener: (context,state){
          if(state is InvoiceFailure){
            showSnackBar(context, state.error);
          }
          if(state is InvoiceDeleteSuccess){
            showSnackBar(context, "Invoice Deleted Successfully");
            context.read<InvoiceBloc>().add(InvoiceFetchAllInvoices(user.id));
          }
        },
        builder: (context,state) {
          if(state is InvoiceLoading){
            return const Loader();
          }
          if(state is InvoiceDisplaySuccess){
            return RefreshIndicator(
              onRefresh: ()async{
                context.read<InvoiceBloc>().add(InvoiceFetchAllInvoices(user.id));
              },
              child: ListView.builder(
                itemCount: state.invoices.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.invoices.length) {
                    final invoice = state.invoices[index];
                    return InvoiceCard(
                      title: invoice.title,
                      content: _tileContent(invoice),
                      color: index % 3 == 0 ? AppPallete.cardColor1 : index % 3 == 1 ? AppPallete.cardColor2 : AppPallete.cardColor3,
                      totalCost: invoice.entries.isNotEmpty ? invoice.entries.map((entry) => entry.rate).reduce((a, b) => a + b) : 0,
                      status: invoice.status,
                    );
                  } else {
                    // Display a SizedBox for the last item
                    return const SizedBox(height: 100); // Adjust height as needed
                  }
                },
              ),
            );
          }
          return const SizedBox();
        }
      ),
    );
  }

  Widget _tileContent(Invoice invoice){
    return Card(
      elevation: 2,
      color: AppPallete.backgroundColor,
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Column(
          children: [
            if(invoice.status != 'Reviewing')...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: invoice.status == 'Approved'? AppPallete.cardColor2: AppPallete.gradient3,
                  borderRadius: BorderRadius.circular(10)
                ) ,
                child: Text(
                  invoice.comments,
                  style: TextStyle(
                      color: invoice.status == 'Approved'? AppPallete.borderColor: AppPallete.errorColor,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
              const SizedBox(height: 10,)
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if(invoice.status != 'Approved')...[
                    OutlinedButton(
                        onPressed: (){
                          _showDeleteConfirmationDialog(invoice.id);
                        },
                        style: _outlinedButtonStyle,
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox( width: 10,),
                            Text("Delete"),
                            SizedBox( width: 5,),
                          ],
                        )
                    ),
                    OutlinedButton(
                        onPressed: (){
                          Navigator.push(context, EditInvoice.route(invoice));
                        },
                        style: _outlinedButtonStyle,
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox( width: 10,),
                            Text("Edit"),
                            SizedBox( width: 5,),
                          ],
                        )
                    ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String invoiceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invoice'),
        content: const Text('Are you sure you want to delete this invoice?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<InvoiceBloc>().add(InvoiceDeleteInvoice(invoiceId, user.id));
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetY;
  final double offsetX;

  CustomFloatingActionButtonLocation({this.offsetY = 100.0, this.offsetX = 20.0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width - offsetX;
    final double fabY = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.floatingActionButtonSize.height - offsetY;
    return Offset(fabX, fabY);
  }
}