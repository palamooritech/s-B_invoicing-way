import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/core/common/widgets/auth_field.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';
import 'package:invoicing_sandb_way/core/utils/loader.dart';
import 'package:invoicing_sandb_way/core/utils/pick_image.dart';
import 'package:invoicing_sandb_way/core/utils/show_snack_bar.dart';
import 'package:invoicing_sandb_way/features/home/presentation/pages/home_page.dart';
import 'package:invoicing_sandb_way/features/useraccount/presentation/bloc/user_account_bloc.dart';
import 'package:invoicing_sandb_way/features/useraccount/presentation/pages/user_account_page.dart';

class EditUserAccount extends StatefulWidget {
  final UserAccount user;
  static route(UserAccount user)=> MaterialPageRoute(
      builder: (context) => EditUserAccount(user: user,)
  );
  const EditUserAccount({super.key, required this.user});

  @override
  State<EditUserAccount> createState() => _EditUserAccountState();
}

class _EditUserAccountState extends State<EditUserAccount> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _selectedRole = 'Guest';
  late String _userImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.emailId);
    _userImagePath = widget.user.profilePicUrl =="" ?
      "https://static.independent.co.uk/2024/04/23/21/2024-04-23T201831Z_1772745914_UP1EK4N1KET6J_RTRMADP_3_SOCCER-ENGLAND-ARS-CHE-REPORT.JPG"
        : widget.user.profilePicUrl;
  }

  void selectImage() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User"),
        centerTitle: true,
      ),
      body: BlocConsumer<UserAccountBloc,UserAccountState>(
        listener: (context,state){
          if(state is UserAccountFailure){
            showSnackBar(context, state.error);
          }
          if(state is UserAccountUploadImageSuccess){
            setState(() {
              _userImagePath = state.imgPath;
            });
          }
          if(state is UserAccountUpdateSuccess){
            Navigator.pushAndRemoveUntil(
                context,
                HomePage.route(),
                (route)=> false
            );
          }
        },
        builder: (context,state) {
          if(state is UserAccountLoading){
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 15.0),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    editProfilePic(),
                    const SizedBox(height: 30,),
                    AuthField(
                        hintText: "Name",
                        textEditingController: _nameController,
                    ),
                    const SizedBox(height: 15,),
                    AuthField(
                        hintText: "Email",
                        textEditingController: _emailController,
                    ),
                    const SizedBox(height: 15,),
                    dropDownFormField(),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                        onPressed: (){
                          final user = widget.user;
                          context.read<UserAccountBloc>().add(
                            UserAccountPutUpdate(
                                UserAccount(
                                    id: user.id,
                                    emailId: _emailController.text.trim(),
                                    name: _nameController.text.trim(),
                                    designation: _selectedRole,
                                    profilePicUrl: _userImagePath,
                                    invoiceCount: user.invoiceCount,
                                )
                            )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 15.0),
                          backgroundColor: AppPallete.gradient2,
                        ),
                        child: const Text("Update",style: TextStyle(
                          color: AppPallete.whiteColor
                        ),)
                    )
                  ],
                ),
              ),
            )
          );
        }
      ),
    );
  }

  DropdownButtonFormField<String> dropDownFormField() {
    return DropdownButtonFormField(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Designation',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Guest','Manager'].map(
                      (role)=> DropdownMenuItem(
                        value: role,
                          child: Text(role),
                      )
                  ).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a role';
                  }
                  return null;
                },
              );
  }

  Stack editProfilePic() {
    return Stack(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 70, // Adjust the radius as needed
                backgroundImage:NetworkImage(_userImagePath),
              ),
              // Icon Button to Change Profile Picture
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () async{
                    final pickedImage = await pickImage();
                    if (!mounted) return;
                    if(pickedImage !=null){
                      context.read<UserAccountBloc>().add(
                          UserAccountUploadImage(
                            pickedImage.path,
                            widget.user.id,
                          )
                      );
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppPallete.gradient3, // Background color for the icon
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0), // Adjust the padding as needed
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
