import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:tile/main.dart';
import 'package:tile/services/auth.dart';
import 'package:flutter/material.dart';


// loadImage() async{
//   //current user id
//   final _userID = FirebaseAuth.instance.currentUser!.uid;

//   //collect the image name
//   DocumentSnapshot variable = await FirebaseFirestore.instance.
//     collection('TileInformation').  
//     doc('user').
//     collection('personal_data').
//     doc(_userID).
//     get();

//     //a list of images names (i need only one)
//     var _file_name = variable['path_profile_image'];



//     //select the image url
//     Reference  ref = FirebaseStorage.instance.ref().child("1_1938.4881.jpg").child(_file_name[0]);
    
//     //get image url from firebase storage
//     var url = await ref.getDownloadURL();
//     //logging
//     print('Image Url: ' + url.toString());
    
//     //return image.network 
//     return Image.network(url.toString());
// }



class SignIn extends StatefulWidget {
  //const SignIn({ Key? key }) : super(key: key);

  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService(); //instance of auth service class which was created in auth.dart 

  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  String error= '';

  Future<String> _url() async {//https://firebase.flutter.dev/docs/storage/download-files
    //var url = await FirebaseStorage.ref('test/dense.png').getDownloadURL();
  // var url = await FirebaseStorage.instance.refFromURL("gs://YOUR_BUCKET/images/stars.jpg");
    final storageRef = FirebaseStorage.instance.ref();
    final imageUrl = await storageRef.child("test/dense.png").getDownloadURL();
    return imageUrl;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        //elevation: 0.0,
        title: Text("Sign In to " + projectTitle),

      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
                      labelText: 'Pasword',
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
                      if (_formKey.currentState!.validate()){
                        dynamic result = await _auth.signInWithEmailandPassword(email, password);
                        if (result==null){
                          setState(() {
                            error = "Can't sign in";
                          });
                          print(error);
                        }

                      }
                      else{
                          setState(() {
                            error = "Please have right parameters";
                          });
                      }
                      
                    }, 
                    child: Text(
                      "Sign In",
                      style: TextStyle(color:Colors.white),
                      ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    child: Text("Guest Login"),
                    onPressed: () async {
                      dynamic result = await _auth.signInAnonymous();
                      if (result==null){
                        print("Error Signing In");
                      }
                      else{
                        print("Signed In");
                        print(result.uid); //custom user
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                            text: 'New? Register Now!',
                            
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Terms of Service"');
                                widget.toggleView();
                              }),
                      ],
                    ),
                  ),
                ]),
              ),
            ),   
          ),
          
          // FutureBuilder(
          //   future: FireStoreDataBase().getData(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasError) {
          //       return const Text(
          //         "Something went wrong",
          //       );
          //     }
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return Image.network(
          //         snapshot.data.toString(),
          //       );
          //     }
          //     return const Center(child: CircularProgressIndicator());
          //   },
          // ),
          
        ],
      ),
    );
  }
}


class FireStoreDataBase {
  String? downloadURL;

  Future getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample() async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child("classic.png")
        .getDownloadURL();
    debugPrint(downloadURL.toString());
  }
}

