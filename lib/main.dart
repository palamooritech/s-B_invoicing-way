import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/common/cubit/appuser/app_user_cubit.dart';
import 'package:invoicing_sandb_way/core/theme/app_theme.dart';
import 'package:invoicing_sandb_way/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/auth/data/repository/auth_repository_impl.dart';
import 'package:invoicing_sandb_way/features/auth/domain/use%20cases/user_sign_up.dart';
import 'package:invoicing_sandb_way/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:invoicing_sandb_way/features/auth/presentation/pages/sign_in_page.dart';
import 'package:invoicing_sandb_way/features/bill/presentation/bloc/bill_bloc.dart';
import 'package:invoicing_sandb_way/features/home/presentation/bloc/home_bloc.dart';
import 'package:invoicing_sandb_way/features/home/presentation/pages/home_page.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/bloc/invoice_bloc.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/pages/invoices_page.dart';
import 'package:invoicing_sandb_way/features/useraccount/presentation/bloc/user_account_bloc.dart';
import 'package:invoicing_sandb_way/firebase_options.dart';
import 'package:invoicing_sandb_way/init_dependencies.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider(create:(_)=> serviceLocator<AuthBloc>()),
          BlocProvider(create: (_)=> serviceLocator<AppUserCubit>()),
          BlocProvider(create: (_)=> serviceLocator<InvoiceBloc>()),
          BlocProvider(create: (_)=> serviceLocator<UserAccountBloc>()),
          BlocProvider(create: (_)=> serviceLocator<BillBloc>()),
          BlocProvider(create: (_)=> serviceLocator<HomeBloc>()),
        ], 
        child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S & B - Invoicing',
      theme: AppTheme.lightThemeMode,
      debugShowCheckedModeBanner: false,
      home: BlocListener<AppUserCubit,AppUserState>(
        listener: (context,state){

        },
        child: BlocBuilder<AppUserCubit,AppUserState>(
          builder: (context, state){
            if(state is AppUserLoggedIn){
              return const HomePage();
            }
            return const SignInPage();
          },
        ),
      )
    );
  }
}

class MaxWidthContainer extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const MaxWidthContainer({required this.maxWidth, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          child: Container(
            width: constraints.maxWidth < maxWidth ? constraints.maxWidth : maxWidth,
            child: child,
          ),
        );
      },
    );
  }
}