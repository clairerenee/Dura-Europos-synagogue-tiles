import 'package:provider/provider.dart';
import 'package:tile/main.dart';
import 'package:tile/screens/authenticate/authenticate.dart';
import 'package:tile/screens/CreateTile/CreateTile.dart';
import 'package:flutter/material.dart';
import 'package:tile/model/user.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print(user);
    //Return either home or authenticate widget
    if (user==null){
      return const Authenticate();
    }
    else{
      return CreateTile();
    }
    //return testy();
    
  }
}