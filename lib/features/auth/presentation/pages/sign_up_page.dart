import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';
import 'package:invoicing_sandb_way/core/utils/loader.dart';
import 'package:invoicing_sandb_way/core/utils/show_snack_bar.dart';
import 'package:invoicing_sandb_way/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:invoicing_sandb_way/features/auth/presentation/pages/sign_in_page.dart';
import 'package:invoicing_sandb_way/core/common/widgets/auth_field.dart';
import 'package:invoicing_sandb_way/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:invoicing_sandb_way/features/home/presentation/pages/home_page.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              }
              if(state is AuthSuccess){
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     HomePage.route(),
                //     (route)=> false,
                // );
              }
            }, builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthField(
                        hintText: "Name",
                        textEditingController: nameController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthField(
                        hintText: "Email",
                        textEditingController: emailController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthField(
                        hintText: "Password",
                        textEditingController: passwordController,
                        isObscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthGradientButton(
                        buttonText: "Sign Up",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthSignUp(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim()));
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(SignInPage.route());
                        },
                        child: RichText(
                            text: TextSpan(
                                text: 'Already have an account? ',
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                              TextSpan(
                                  text: "Sign In",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: AppPallete.gradient2))
                            ])),
                      )
                    ],
                  ),
                ),
              );
            })));
  }
}
