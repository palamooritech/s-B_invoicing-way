import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/cubit/appuser/app_user_cubit.dart';
import 'package:invoicing_sandb_way/core/common/entity/user.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';
import 'package:invoicing_sandb_way/core/utils/loader.dart';
import 'package:invoicing_sandb_way/core/utils/show_snack_bar.dart';
import 'package:invoicing_sandb_way/features/useraccount/presentation/bloc/user_account_bloc.dart';
import 'package:invoicing_sandb_way/features/useraccount/presentation/pages/edit_user_account.dart';

class UserAccountPage extends StatefulWidget {
  static route()=> MaterialPageRoute(
      builder: (context)=> const UserAccountPage()
  );
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    context.read<UserAccountBloc>().add(UserAccountGetStatus(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<UserAccountBloc, UserAccountState>(
            listener: (context, state) {
              if (state is UserAccountFailure) {
                showSnackBar(context, state.error);
              }
              if (state is UserAccountStatusFlag) {
                if (state.flag) {
                  Navigator.push(context, EditUserAccount.route(
                      UserAccount(
                        id: user.id,
                        emailId: user.email,
                        name: user.name,
                        designation: "",
                        profilePicUrl: "",
                        invoiceCount: 0,
                      )
                  )
                  );
                } else{
                  context.read<UserAccountBloc>().add(UserAccountGetAccount(user.id));
                }
              }
            },
            builder: (context, state) {
              if(state is UserAccountDisplaySuccess){
                return _buildUserAccountDetails(state.userAccount);
              }
              return const Loader();
            }
        )
    );
  }

  Widget _buildUserAccountDetails(UserAccount userAccount) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserImage(userAccount.profilePicUrl),
          const SizedBox(height: 20),
          _buildInfoCard(userAccount.invoiceCount),
          const SizedBox(height: 20),
          _buildInfoTile('Name', userAccount.name),
          const SizedBox(height: 10),
          _buildInfoTile('Email', userAccount.emailId),
          const SizedBox(height: 10),
          _buildInfoTile('Designation', userAccount.designation),
          ElevatedButton(
              onPressed: (){
                Navigator.push(context, EditUserAccount.route(userAccount));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit,size: 25,),
                    SizedBox(width: 10,),
                    Text("Edit",style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                    ),),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget _buildUserImage(String imageUrl) {
    return GestureDetector(
      onTap: () {
        // Handle image tap action (e.g., change profile picture)
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: AppPallete.gradient1),
          image: DecorationImage(
            image: NetworkImage(imageUrl), // Use NetworkImage to load from URL
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(int invoiceCount) {
    return Card(
      color: AppPallete.gradient3,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const Text(
              'Invoice Count',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '$invoiceCount', // Display the invoice count dynamically
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: AppPallete.gradient1, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

}
