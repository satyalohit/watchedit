import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moviesapp/providers/movies_provider.dart';
import 'package:moviesapp/screens/homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  Container(
                    child: Image.asset("assets/movies.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Login to keep track of movies you watched",
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.only(top: 10),
                    height: 46,
                    child: OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () async {
                        await _handleSignIn();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                      highlightElevation: 0,
                      borderSide: BorderSide(color: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                                image: AssetImage("assets/google_logo.png"),
                                height: 22.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Sign in with Google',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.getString("email"));
      if (prefs.getString("email") != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(
                  _handleSignOut,
                )));
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }();
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _googleSignIn.signIn().then((value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          _currentUser = value;

          prefs.setString("email", _currentUser!.email);
          _isLoading = true;
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(_handleSignOut),
          ));
        });
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect().then((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      prefs.remove("email");
    });
    return;
  }
}
