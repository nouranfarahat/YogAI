import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/signUp_bloc/signup_bloc.dart';
import '../../bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../../main.dart';
import '../DBicons.dart';
import 'bottom_nav_bar_screen.dart';
import 'login_screen.dart';

class signUpScreen extends StatefulWidget {

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  DateTime selectedDate = DateTime.now();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  final _signupBloc = BlocProvider.of<SignupBloc>(context);
    return Scaffold(

      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignUpSuccessfully) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) =>BottomNavBarScreen()));

          }
          if (state is SignUpError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UnAuthenticated) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
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
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  hintText: "username",
                                  border: OutlineInputBorder(),
                                ),
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value == null
                                      ? 'this username is already used'
                                      : null;
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
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
                              TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "confirm-Password",
                                  border: OutlineInputBorder(),
                                ),
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value != _passwordController.text ||
                                      value == null
                                      ? "please make sure both passwords match"
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  child:Column(

                                    children: <Widget>[
                                      Text("${selectedDate.toLocal()}".split(
                                          ' ')[0]),
                                      SizedBox(height: 20.0,),
                                      ElevatedButton( style: ElevatedButton.styleFrom(
                                        primary:Colors.redAccent,
                                      ),
                                        onPressed: () => _selectDate(context),
                                        child: Text('Select date'),
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.7,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary:Colors.redAccent, // set the background color

                                   // animationDuration:Duration(milliseconds: 1000),

                                  ),
                                  onPressed: () {
                                    _createAccountWithEmailAndPassword(context);
                                  },
                                  child: const Text('Sign Up'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                       TextButton(
                          child:Text("Already have an account?",style:TextStyle(color:Colors.redAccent ,)),
                          onPressed:() {
                            Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) =>
                                  loginScreen()));

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
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }}

    void _createAccountWithEmailAndPassword(BuildContext context) {
      if (_formKey.currentState!.validate()) {
        BlocProvider.of<SignupBloc>(context).add(
          SignUpRequested(
            email: _emailController.text,
            password: _passwordController.text,
            username: _usernameController.text,
            DOB: selectedDate,
          ),
        );
      }
    }

}