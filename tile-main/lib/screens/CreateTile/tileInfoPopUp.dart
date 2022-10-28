import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget imageDialog(tileList, index, context) {
  final String subject = tileList[index].subject;
  final String date = tileList[index].date;
  final String context = tileList[index].context;
  final List relevantLinks = tileList[index].relevantLinks;
  final String translation = tileList[index].translation;

  return Dialog(
    child: Container(
      height: 600,
      width: 900,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                // flex: 9,
                child: AspectRatio(
                  aspectRatio: 1,
                  //child: Image.asset(imageName),
                  child: Image.asset("assets/"+tileList[index].photoId),
                ),
              ),
            ],
          ),
          Flexible(child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,  
                    style: const TextStyle(color: Colors.red, fontSize: 24)
                  ),
                  Text(
                    date, 
                    style: const TextStyle(color: Colors.black)
                  ),
                  Padding(padding: const EdgeInsets.all(16.0), child: Text(context)),
                  Padding(padding: const EdgeInsets.all(16.0), child: Text(translation)),
                  const Padding(padding: EdgeInsets.all(16.0), child: Text("Click Below For More Information:")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child:  ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.brown,
                          ),
                          child: const Text("YUAG"),
                          onPressed: () => launchUrl(Uri.parse(relevantLinks[0])),
                        ),
                        //onTap: () => launchUrl(Uri.parse(relevantLinks[0])),
                      ),
                      const SizedBox(width: 25,),
                      InkWell(
                        child:  ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.brown,
                          ),
                          child: const Text("WikiData"),
                          onPressed: () => launchUrl(Uri.parse(relevantLinks[1])),
                        ),
                        //onTap: () => launchUrl(Uri.parse(relevantLinks[0])),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
          
        ]
      )
    )
  );
}
