import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/cubit/appuser/app_user_cubit.dart';
import 'package:invoicing_sandb_way/core/common/entity/invoice.dart';
import 'package:invoicing_sandb_way/core/common/widgets/auth_field.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';
import 'package:invoicing_sandb_way/core/utils/loader.dart';
import 'package:invoicing_sandb_way/core/utils/show_snack_bar.dart';
import 'package:invoicing_sandb_way/features/home/presentation/pages/home_page.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/bloc/invoice_bloc.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/pages/invoices_page.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/widgets/date_picker_text_field.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/widgets/deletable_list_tile.dart';

class AddNewInvoice extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (context) => const AddNewInvoice());

  const AddNewInvoice({Key? key}) : super(key: key);

  @override
  State<AddNewInvoice> createState() => _AddNewInvoiceState();
}

class _AddNewInvoiceState extends State<AddNewInvoice> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  bool _sameDate = true;
  List<InvoiceEntry> _entries = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add New Invoice'),
        actions: [
          IconButton(
              onPressed: (){
                if(_formKey.currentState!.validate() && _startDateController.text != null){
                  final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
                  context.read<InvoiceBloc>().add(
                      InvoiceUpload(
                          authorId: posterId,
                          title: _titleController.text.trim(),
                          description: _descriptionController.text.trim(),
                          startData: DateTime.parse(_startDateController.text.trim()),
                          endDate:  _sameDate ? DateTime.parse(_startDateController.text.trim()) : DateTime.parse(_endDateController.text.trim()),
                          entries: _entries
                      )
                  );
                }
                if(_startDateController.text == null){
                  showSnackBar(context, "Please Select the Date");
                }
              },
              icon: const Icon(Icons.save, size: 40,)
          ),
        ],
      ),
      body: BlocConsumer<InvoiceBloc,InvoiceState>(
        listener: (context,state){
          if(state is InvoiceFailure){
            showSnackBar(context, state.error);
          }else if(state is InvoiceUploadSuccess){
            Navigator.pushAndRemoveUntil(
                context,
                HomePage.route(),
                (route)=>false
            );
          }
        },
        builder: (context,state) {
          if(state is InvoiceLoading){
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthField(
                      hintText: 'Title',
                      textEditingController:  _titleController
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    textEditingController: _descriptionController,
                    hintText: 'Description',
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Checkbox(
                        value: !_sameDate,
                        onChanged: (value) {
                          setState(() {
                            _sameDate = !(value ?? false);
                            if (_sameDate) {
                              _endDateController.clear();
                            }
                          });
                        },
                      ),
                      const Text('Start and end dates are different'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: DatePickerTextField(
                            controller: _startDateController,
                            labelText: 'Start Date',
                           ),
                        ),
                        if (!_sameDate) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: DatePickerTextField(
                              controller: _endDateController,
                              firstDate: DateTime.parse(_startDateController.text.trim()),
                              labelText: 'End Date',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildAddEntryButton(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        final entry = _entries[index];
                        return DeletableListTile(
                          title: entry.description,
                          subtitle: '${entry.rate} INR',
                          onDelete: (){
                            setState(() {
                              _entries.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildAddEntryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _addEntryDialogBox();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.gradient1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 4.0,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 20.0,
                color: Colors.white,
              ),
              SizedBox(width: 10.0),
              Text(
                'Add Entry',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addEntryDialogBox() async {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Entry",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Cost Incurred',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _entries.add(
                            InvoiceEntry(
                              description: _nameController.text.trim(),
                              kms: 0,
                              rate:int.parse(_priceController.text.trim()),
                            ),
                          );
                        });
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle_rounded),
                          SizedBox(width: 10),
                          Text("Add"),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
