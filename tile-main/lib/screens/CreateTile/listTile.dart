import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tile/screens/CreateTile/tileInfoPopUp.dart';


class sideTileImage extends StatelessWidget {
  final int index;
  final List<Tile> tileList;

  const sideTileImage(this.index, this.tileList);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset("assets/"+tileList[index].photoId),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 10,
              child: Container(
                //padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(tileList[index].subject, style: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255))),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(50, 30, 30, 30),
                          ),
                                onPressed: () async {
                                   await showDialog(
                                        context: context,
                                        //builder: (_) => tileInfoPopUp()
                                        builder: (_) => imageDialog(tileList, index, context),
                                    );
                                },
                                child: const Text("More Info",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ]
        ),
      )
    );
  }
}

class Tile { //https://stackoverflow.com/questions/71014768/flutter-how-can-i-print-all-my-data-fields-from-firebase-documents
  final String subject;
  final String date;
  final String context;
  final String imageUrl;
  final List relevantLinks;
  final String translation;
  final String photoId;

  const Tile({
    required this.subject,
    required this.date,
    required this.context,
    required this.imageUrl,
    required this.relevantLinks,
    required this.translation,
    required this.photoId,
  });

  factory Tile.fromMap(Map<String, dynamic> map) {
    return Tile(     
      subject: map['subject'] as String,
      date: map['date'] as String,
      context: map['context'] as String,
      imageUrl: map['imageUrl'] as String,
      relevantLinks: map['relevantLinks'] as List,
      translation: map['translation'] as String,
      photoId: map['photoId'] as String,
    );
  }
}

