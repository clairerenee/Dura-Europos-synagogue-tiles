import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tile/services/auth.dart';

class Register extends StatefulWidget {
  //const Register({ Key? key }) : super(key: key);

  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        //elevation: 0.0,
        title: Text("Sign Up to Dura Tiles"),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              // child: ElevatedButton(
              //   child: Text("Sign In Anonymously"),
              //   onPressed: () async {
              //     dynamic result = await _auth.signInAnonymous();
              //     if (result==null){
              //       print("Error Signing In");
              //     }
              //     else{
              //       print("Signed In");
              //       print(result.uid); //custom user
              //     }
              //   },
              // ),
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (val){

                        setState(() {
                          email = val;
                        });
                      
                    },
                    validator: (val){
                      val!.isEmpty ? 'Enter a email' : null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (val){
                      val!.length < 6 ? 'Enter a password 6+ chars long' : null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue,),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        dynamic result = _auth.registerWithEmailandPassword(email, password);
                      }
                      else{
                        setState(() {
                          error = "Please have right parameters";
                        });
                      }
                      
                    }, 
                    
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color:Colors.white),
                      ),
                  ),
                ]),
              ),
            ),   
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                    text: 'Go back to Sign In',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Terms of Service"');
                        widget.toggleView();
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}