import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/auth/auth_controller.dart';
import 'package:money_tracker/const/auth_types.dart';
import 'package:sign_in_button/sign_in_button.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AIO Tracker"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: _user != null ? _userInfo() : _buildAuthenticationPageUI()),
    );
  }

  Widget _buildAuthenticationPageUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAppTitle(),
          _buildSignInComponent(),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return const Text(
      "Money Tracker",
      style: TextStyle(
        fontSize: 35,
      ),
    );
  }

  Widget _buildSignInComponent() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.90,
        height: MediaQuery.sizeOf(context).height * 0.30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildWelcomeMessage(), _buildGoogleSiginButton()],
        ));
  }

  Widget _buildWelcomeMessage() {
    return const Text(
      "Welcome to Money tracker.\nWe are happy to have you aboard.\nSign in with your google account to continue.",
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGoogleSiginButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign In with Google",
          onPressed: () => _doSignIn(googleAuth),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_user!.photoURL!),
              ),
            ),
          ),
          Text(_user!.email!),
          Text(_user!.displayName ?? ""),
          ElevatedButton(onPressed: _doSignOut, child: const Text("Sign Out"))
        ],
      ),
    );
  }

  void _doSignIn(String authType) {
    AuthenticationController().handleSignIn(authType);
  }

  void _doSignOut() {
    AuthenticationController().handleSignOut();
  }
}
