import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/cubit/appuser/app_user_cubit.dart';
import 'package:invoicing_sandb_way/core/common/entity/user.dart';
import 'package:invoicing_sandb_way/core/common/entity/user_account.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';
import 'package:invoicing_sandb_way/core/utils/loader.dart';
import 'package:invoicing_sandb_way/core/utils/show_snack_bar.dart';
import 'package:invoicing_sandb_way/features/bill/presentation/pages/bills_page.dart';
import 'package:invoicing_sandb_way/features/home/presentation/bloc/home_bloc.dart';
import 'package:invoicing_sandb_way/features/home/presentation/widget/floating_bottom_nav_bar.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/pages/invoices_page.dart';
import 'package:invoicing_sandb_way/features/useraccount/presentation/pages/edit_user_account.dart';
import 'package:invoicing_sandb_way/features/useraccount/presentation/pages/user_account_page.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late User user;
  late bool newUserFlag;

  static const List<Widget> _userPages = <Widget>[
    InvoicesPage(),
    UserAccountPage(),
  ];

  static const List<Widget> _adminPages = <Widget>[
    BillsPage(),
    UserAccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    context.read<HomeBloc>().add(HomeFetchUserNewFlagEvent(id: user.id));
    // newUserFlag = (context.read<HomeBloc>().state as HomeFetchUserNewFlagSuccessState).flag;
    // context.read<HomeBloc>().add(HomeFetchUserFlagEvent(id: user.id));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("S & B"),
          centerTitle: true,
        ),
        body: BlocConsumer<HomeBloc,HomeState>(
          listener: (context,state){
            if(state is HomeFailureState){
              showSnackBar(context, 'Home Page Error - ${state.error}');
            }
            if(state is HomeFetchUserNewFlagSuccessState){
              if(state.flag){
                Navigator.pushReplacement(
                    context,
                    EditUserAccount.route(
                      UserAccount(
                          id: user.id,
                          emailId: user.email,
                          name: user.name,
                          designation: "Guest",
                          profilePicUrl: "",
                          invoiceCount: 0
                      )
                    )
                );
              }else{
                context.read<HomeBloc>().add(HomeFetchUserFlagEvent(id: user.id));
              }
            }
          },
          builder: (context,state) {
            if(state is HomeFetchUserFlagSuccessState){
              return Stack(
                children: [
                  IndexedStack(
                    index: _selectedIndex,
                    children: state.flag?_adminPages:_userPages,
                  ),
                  Positioned(
                    bottom: 10.0,
                    left: 16.0,
                    right: 16.0,
                    child: FloatingBottomNavBar(
                      onItemTapped: _onItemTapped,
                      flag: state.flag,
                    ),
                  ),
                ],
              );
            }
            return const Loader();
          }
        ),
    );
  }
}