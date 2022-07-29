import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_ai/presentation/screens/registeration_screen.dart';
import '../../Bloc/login_bloc/login_bloc.dart';
import '../../bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../../main.dart';
import '../DBicons.dart';
import 'bottom_nav_bar_screen.dart';

class loginScreen extends StatefulWidget {


  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is loginSuccessfully) {

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) =>BottomNavBarScreen()));
           /*
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) =>BlocProvider.value(
                  value: BlocProvider.of<AuthBloc>(context),
                  child: HomeScreen(),
                )));*/
          }
          if (state is loginError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UnAuthenticated) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/Logo.png",width: 100,height: 100,),
                        const Text(
                          "YogAi",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                              color: Colors.lightBlueAccent

                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null &&
                                        !EmailValidator.validate(value)
                                        ? 'Enter a valid email'
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  obscureText:true,
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null && value.length < 6
                                        ? "Enter min. 6 characters"
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                SizedBox(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.7,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary:Colors.redAccent, // set the background color

                                      // animationDuration:Duration(milliseconds: 1000),

                                    ),
                                    onPressed: () {
                                      _authenticateWithEmailAndPassword(
                                          context);
                                    },
                                    child: const Text('Sign In'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                            child:Text("Don't have an account ?",style:TextStyle(color:Colors.redAccent ,)),
                            onPressed:() {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => signUpScreen()),
                              );
                            }),

                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<LoginBloc>(context).add(
        SignInRequested(email:_emailController.text,password: _passwordController.text),
      );
    }
  }


}