import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:invoicing_sandb_way/core/common/entity/bill.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';
import 'package:invoicing_sandb_way/core/utils/loader.dart';
import 'package:invoicing_sandb_way/core/utils/pdf_bill_generator.dart';
import 'package:invoicing_sandb_way/core/utils/show_snack_bar.dart';
import 'package:invoicing_sandb_way/features/bill/presentation/bloc/bill_bloc.dart';
import 'package:invoicing_sandb_way/features/bill/presentation/widgets/dotted_divider.dart';
import 'package:invoicing_sandb_way/features/home/presentation/pages/home_page.dart';

class ViewInvoiceDetailsPage extends StatefulWidget {
  final Bill bill;
  static Route route(Bill bill) => MaterialPageRoute(
      builder: (context) => ViewInvoiceDetailsPage(bill: bill));

  ViewInvoiceDetailsPage({required this.bill});

  @override
  State<ViewInvoiceDetailsPage> createState() => _ViewInvoiceDetailsPageState();
}

class _ViewInvoiceDetailsPageState extends State<ViewInvoiceDetailsPage> {
  late TextEditingController _paidAmountController;
  late TextEditingController _commentsController;
  late Invoice invoice;
  late double pendingAmount;

  @override
  void initState() {
    super.initState();
    _paidAmountController = TextEditingController(text: widget.bill.paidAmount.toString());
    _commentsController = TextEditingController(text: ''); // Assuming comments are not part of BillModel
    invoice = widget.bill.invoice;
    pendingAmount = widget.bill.pendingAmount;

    _paidAmountController.addListener(() {
      setState(() {
        double paidAmount = double.tryParse(_paidAmountController.text) ?? 0.0;
        pendingAmount = widget.bill.pendingAmount - paidAmount;
      });
    });
  }

  @override
  void dispose() {
    _commentsController.dispose();
    _paidAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
      ),
      body: BlocConsumer<BillBloc, BillState>(
        listener: (context, state) {
          if (state is BillFailureState) {
            showSnackBar(context, state.error);
          }
          if (state is BillApproveSuccessState || state is BillRejectSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                HomePage.route(),
                (route)=> false,
            );
          }
        },
        builder: (context, state) {
          if (state is BillLoadingState) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildDetailRow('Title', invoice.title),
                _buildDetailRow('Description', invoice.description),
                _buildDetailRow('Start Date', DateFormat('yyyy-MM-dd').format(invoice.startData)),
                _buildDetailRow('End Date', DateFormat('yyyy-MM-dd').format(invoice.endDate)),
                _buildDetailRow('Status', invoice.status),
                _buildDetailRow('Last Updated', DateFormat('yyyy-MM-dd').format(invoice.updatedAt)),
                _buildDetailRow('Pending Amount', "₹ ${pendingAmount.toString()}", true),
                const Divider(),
                ...invoice.entries.map((entry) => _buildEntryDetail(entry)).toList(),
                if (widget.bill.status == BillStatus.Approved || widget.bill.status == BillStatus.Rejected)
                  Column(
                    children: [
                      const SizedBox(height: 5,),
                      _buildDetailRow('Paid Amount',  widget.bill.paidAmount.toString(), true),
                      _buildDetailRow('Comments', widget.bill.invoice.comments, true), // Adjust as needed for comments
                      const SizedBox(height: 16),
                      if(widget.bill.status == BillStatus.Approved) ...[
                        ElevatedButton(
                          onPressed: () {
                            generatePdf(context, widget.bill);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10,),
                                Icon(Icons.download_sharp, size: 20,),
                                SizedBox(width: 5,),
                                Text('Download', style: TextStyle(fontSize: 18),),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildTextField('Paid Amount', _paidAmountController),
                      _buildTextField('Comments', _commentsController),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<BillBloc>().add(
                                BillApproveEvent(
                                  widget.bill,
                                  _commentsController.text.trim(),
                                  double.parse(_paidAmountController.text.trim()),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete.gradient2,
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, size: 20),
                                SizedBox(width: 5),
                                Text('Approve'),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<BillBloc>().add(
                                BillRejectEvent(
                                  widget.bill,
                                  _commentsController.text.trim(),
                                  double.parse(_paidAmountController.text.trim()),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete.errorColor,
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.cancel_rounded, size: 20),
                                SizedBox(width: 5),
                                Text('Reject'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, [bool flag = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (!flag) ...[Text(value)] else ...[
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppPallete.gradient3,
              ),
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEntryDetail(InvoiceEntry entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Entry:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        _buildDetailRow('Description', entry.description),
        _buildDetailRow('Rate', entry.rate.toString()),
        if (entry.kms > 0) ...[_buildDetailRow('KMs', entry.kms.toString())],
        const DottedDivider(),
        const SizedBox(height: 10,)
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
