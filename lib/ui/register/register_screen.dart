// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/model/user.dart' as MyUser;
import 'package:todo_app/database/my_database.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/ui/component/custom_form_field.dart';
import 'package:todo_app/ui/dialog_utils.dart';
import 'package:todo_app/ui/home/home_screen.dart';
import 'package:todo_app/ui/login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController namController =
      TextEditingController(text: 'Emad Hanna');

  TextEditingController emailController =
      TextEditingController(text: 'emadhanna@gmail.com');

  TextEditingController passwordController =
      TextEditingController(text: '123456');

  TextEditingController confirmPasswordController =
      TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffDFECDB),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/sign_in_background.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Register'),
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
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  CustomFormField(
                    controller: namController,
                    label: 'Full Name',
                    hintText: 'please enter Full Name ',
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'please enter full name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomFormField(
                    controller: emailController,
                    label: 'Email Address',
                    hintText: 'please enter email address ',
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'please enter email';
                      }
                      var regex = RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                      if (!regex.hasMatch(text)) {
                        return 'please enter a valid email';
                      } else {
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
                      if (text == null || text.trim().isEmpty) {
                        return 'please enter password';
                      }
                      if (text.length < 6) {
                        return 'password should be least 6 character';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomFormField(
                    controller: confirmPasswordController,
                    label: 'Confirm Password',
                    hintText: 'please enter repeated password ',
                    keyboardType: TextInputType.text,
                    isPassword: true,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'please enter confirmation password';
                      }
                      if (passwordController.text != text) {
                        return "password doesn't match";
                      } else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        register();
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      child: Text("Don't have an Account ")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth authService = FirebaseAuth.instance;

  void register() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    // logic register
    DialogUtils.showLoadingDialog(context, 'Loading.....');
    try {
      var result = await authService.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      var myUser = MyUser.User(
        id: result.user?.uid,
        name: namController.text,
        email: emailController.text,
      );
      await MyDataBase.addUser(myUser);
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateUser(myUser);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'user registered successfully',
          postActionName: 'Ok', postAction: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }, dismissible: false);
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      String errorMessage = 'Something want wrong';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      DialogUtils.showMessage(context, errorMessage, postActionName: 'ok');
    } catch (e) {
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, e as String,
          postActionName: 'cancel', nagActionName: 'try again', nagAction: () {
        register();
      });
    }
  }
}
