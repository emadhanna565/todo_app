// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/my_database.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/ui/component/custom_form_field.dart';
import 'package:todo_app/ui/dialog_utils.dart';
import 'package:todo_app/ui/home/home_screen.dart';
import 'package:todo_app/ui/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController(
      text: 'emadhanna@gmail.com');
  TextEditingController passwordController = TextEditingController(
      text: '123456');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffDFECDB),
        image: DecorationImage(
          image: AssetImage('assets/images/sign_in_background.png',),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.25,
                  ),
                  CustomFormField(
                    controller: emailController,
                    label: 'Email Address',
                    hintText: 'please enter email address ',
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text == null || text
                          .trim()
                          .isEmpty) {
                        return 'please enter email';
                      }
                      var regex = RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                      if (!regex.hasMatch(text)) {
                        return 'please enter a valid email';
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  CustomFormField(
                    controller: passwordController,
                    label: 'Password',
                    hintText: 'please enter password ',
                    keyboardType: TextInputType.text,
                    isPassword: true,
                    validator: (text) {
                      if (text == null || text
                          .trim()
                          .isEmpty) {
                        return 'please enter password';
                      }
                      if (text.length < 6) {
                        return 'password should be least 6 character';
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12,),
                      ),
                      onPressed: () {
                        login();
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 24
                        ),
                      ),
                    ),
                  ),
                  TextButton(onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RegisterScreen.routeName);
                  }, child: Text("Don't have an Account ")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth authService = FirebaseAuth.instance;

  void login() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    // logic register
    DialogUtils.showLoadingDialog(context, 'Loading.....');
    try {
      var result = await authService.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      DialogUtils.hideDialog(context);
      var user = await MyDataBase.readUser(result.user?.uid ?? "");
      if (user == null) {
        DialogUtils.showMessage(
            context, "error can't find user in database", postActionName: 'ok');
        return;
      }
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateUser(user);

      DialogUtils.showMessage(
          context, 'user logged in Successfully', dismissible: false,
          postActionName: 'ok',
          postAction: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          });
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      String errorMessage = 'Something want wrong';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
      DialogUtils.showMessage(context, errorMessage, postActionName: 'ok');
    }
    catch (e) {
      await Future.delayed(Duration(seconds: 3));
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(
          context,
          e as String,
          postActionName: 'cancel',
          nagActionName: 'try again',
          nagAction: () {
            login();
          });
    }
  }
}
