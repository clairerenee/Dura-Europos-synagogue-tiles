import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tile/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:tile/services/auth.dart';
import 'package:tile/model/user.dart';

String projectTitle = "DE Synagogue Tile Explorer";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
