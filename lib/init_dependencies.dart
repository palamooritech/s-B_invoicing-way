import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:invoicing_sandb_way/core/common/cubit/appuser/app_user_cubit.dart';
import 'package:invoicing_sandb_way/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/auth/data/repository/auth_repository_impl.dart';
import 'package:invoicing_sandb_way/features/auth/domain/repository/auth_repository.dart';
import 'package:invoicing_sandb_way/features/auth/domain/use%20cases/current_user.dart';
import 'package:invoicing_sandb_way/features/auth/domain/use%20cases/user_sign_in.dart';
import 'package:invoicing_sandb_way/features/auth/domain/use%20cases/user_sign_up.dart';
import 'package:invoicing_sandb_way/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:invoicing_sandb_way/features/bill/data/datasources/bill_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/bill/data/repository/bill_repository_impl.dart';
import 'package:invoicing_sandb_way/features/bill/domain/repository/bill_repository.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/approve_bill.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/delete_bill.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/get_all_bills.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/reject_bill.dart';
import 'package:invoicing_sandb_way/features/bill/domain/usecases/update_Bill.dart';
import 'package:invoicing_sandb_way/features/bill/presentation/bloc/bill_bloc.dart';
import 'package:invoicing_sandb_way/features/home/data/datasources/home_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/home/data/repository/home_repository_impl.dart';
import 'package:invoicing_sandb_way/features/home/domain/repository/home_repository.dart';
import 'package:invoicing_sandb_way/features/home/domain/usecases/get_user_role.dart';
import 'package:invoicing_sandb_way/features/home/domain/usecases/user_status_check.dart';
import 'package:invoicing_sandb_way/features/home/presentation/bloc/home_bloc.dart';
import 'package:invoicing_sandb_way/features/invoices/data/datasources/invoice_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/invoices/data/repository/invoice_repository_impl.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/repository/invoice_repository.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/usecase/delete_invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/usecase/get_all_invoices.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/usecase/update_invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/domain/usecase/upload_invoice.dart';
import 'package:invoicing_sandb_way/features/invoices/presentation/bloc/invoice_bloc.dart';
import 'package:invoicing_sandb_way/features/useraccount/data/datasources/user_account_remote_data_source.dart';
import 'package:invoicing_sandb_way/features/useraccount/data/repository/user_account_repository_impl.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/repository/user_account_repository.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/usecases/get_user_details.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/usecases/status_user_details.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/usecases/update_user_details.dart';
import 'package:invoicing_sandb_way/features/useraccount/domain/usecases/upload_user_image.dart';
import 'package:invoicing_sandb_way/features/useraccount/presentation/bloc/user_account_bloc.dart';
import 'package:invoicing_sandb_way/firebase_options.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final fb = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  serviceLocator
      .registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  serviceLocator.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
  serviceLocator
      .registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  _initAuth();
  _initInvoices();
  _initUserAccount();
  _initBills();
  _initHome();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator(),serviceLocator()))
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator()))
    ..registerFactory<UserSignUp>(() => UserSignUp(serviceLocator()))
    ..registerFactory<UserSignIn>(() => UserSignIn(serviceLocator()))
    ..registerFactory<CurrentUser>(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton<AuthBloc>(() => AuthBloc(
          userSignUp: serviceLocator(),
          userSignIn: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
        ));
}

void _initInvoices() {
  serviceLocator
    ..registerFactory<InvoiceRemoteDataSource>(
        () => InvoiceRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<InvoiceRepository>(
        () => InvoiceRepositoryImpl(serviceLocator()))
    ..registerFactory<GetAllInvoices>(() => GetAllInvoices(serviceLocator()))
    ..registerFactory<UploadInvoice>(() => UploadInvoice(serviceLocator()))
    ..registerFactory<UpdateInvoice>(() => UpdateInvoice(serviceLocator()))
    ..registerFactory<DeleteInvoice>(() => DeleteInvoice(serviceLocator()))
    ..registerLazySingleton<InvoiceBloc>(() => InvoiceBloc(
          getAllInvoices: serviceLocator(),
          uploadInvoice: serviceLocator(),
          updateInvoice: serviceLocator(),
          deleteInvoice: serviceLocator(),
        ));
}

void _initUserAccount() {
  serviceLocator
    ..registerFactory<UserAccountRemoteDataSource>(() =>
        UserAccountRemoteDataSourceImpl(serviceLocator(), serviceLocator()))
    ..registerFactory<UserAccountRepository>(
        () => UserAccountRepositoryImpl(serviceLocator()))
    ..registerFactory<UpdateUserDetails>(
        () => UpdateUserDetails(serviceLocator()))
    ..registerFactory<StatusUserDetails>(
        () => StatusUserDetails(serviceLocator()))
    ..registerFactory<GetUserDetails>(() => GetUserDetails(serviceLocator()))
    ..registerFactory<UploadUserImage>(() => UploadUserImage(serviceLocator()))
    ..registerLazySingleton<UserAccountBloc>(() => UserAccountBloc(
          getUserDetails: serviceLocator(),
          statusUserDetails: serviceLocator(),
          updateUserDetails: serviceLocator(),
          uploadUserImage: serviceLocator(),
        ));
}

void _initBills() {
  serviceLocator
    ..registerFactory<BillRemoteDataSource>(
        () => BillRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<BillRepository>(
        () => BillRepositoryImpl(serviceLocator()))
    ..registerFactory<GetAllBills>(() => GetAllBills(serviceLocator()))
    ..registerFactory<UpdateBill>(() => UpdateBill(serviceLocator()))
    ..registerFactory<DeleteBill>(() => DeleteBill(serviceLocator()))
    ..registerFactory<ApproveBill>(() => ApproveBill(serviceLocator()))
    ..registerFactory<RejectBill>(() => RejectBill(serviceLocator()))
    ..registerLazySingleton<BillBloc>(() => BillBloc(
          getAllBills: serviceLocator(),
          deleteBill: serviceLocator(),
          updateBill: serviceLocator(),
          approveBill: serviceLocator(),
          rejectBill: serviceLocator(),
        ));
}

void _initHome() {
  serviceLocator
    ..registerFactory<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<HomeRepository>(
        () => HomeRepositoryImpl(serviceLocator()))
    ..registerFactory<GetUserRole>(() => GetUserRole(serviceLocator()))
    ..registerFactory<UserStatusCheck>(() => UserStatusCheck(serviceLocator()))
    ..registerLazySingleton<HomeBloc>(
        () => HomeBloc(
            getUserRole: serviceLocator(),
          userStatusCheck: serviceLocator(),
        )
    );
}
