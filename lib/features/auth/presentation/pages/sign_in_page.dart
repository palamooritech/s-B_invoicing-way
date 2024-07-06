import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';
import 'package:invoicing_sandb_way/core/utils/loader.dart';
import 'package:invoicing_sandb_way/core/utils/show_snack_bar.dart';
import 'package:invoicing_sandb_way/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:invoicing_sandb_way/features/auth/presentation/pages/sign_up_page.dart';
import 'package:invoicing_sandb_way/core/common/widgets/auth_field.dart';
import 'package:invoicing_sandb_way/features/auth/presentation/widgets/auth_gradient_button.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => SignInPage()
  );
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc,AuthState>(
          listener: (context,state){
            if(state is AuthFailure){
              showSnackBar(context, state.message);
            }
          },
          builder: (context,state) {
            if(state is AuthLoading){
              return const Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 30,),
                  AuthField(
                    hintText: "Email", textEditingController: emailController,),
                  const SizedBox(height: 15,),
                  AuthField(hintText: "Password",
                    textEditingController: passwordController,
                    isObscureText: true,),
                  const SizedBox(height: 20,),
                  AuthGradientButton(
                      buttonText: "Sign In",
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          context.read<AuthBloc>().add(
                              AuthSignIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim()
                              )
                          );
                        }
                      }
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(SignUpPage.route());
                    },
                    child: RichText(
                        text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleMedium,
                            children: [
                              TextSpan(
                                  text: "Sign Up",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                      color: AppPallete.gradient2
                                  )
                              )
                            ]
                        )
                    ),
                  )
                ],
              ),
            );
          }
        )
      ),
    );
  }
}
