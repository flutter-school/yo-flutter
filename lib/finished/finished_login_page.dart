import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yo/finished/finished_session_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Widget _buildSignInButton() {
    return MaterialButton(
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.person),
              SizedBox(width: 8),
              Text("Login with Google"),
            ],
          ),
        ),
        onPressed: _onSignInClicked);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF6C5B7B),
        body: Container(
          child: Center(
            child: Text("Yo!",
                style: Theme.of(context)
                    .textTheme
                    .display4
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 64,
          child: Center(
            child:
                _isLoading ? CircularProgressIndicator() : _buildSignInButton(),
          ),
        ),
      ),
    );
  }

  void _onSignInClicked() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ScopedModel.of<FinishedSessionModel>(context).googleLogin();
    } catch (e) {
      print("Error logging in $e");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
