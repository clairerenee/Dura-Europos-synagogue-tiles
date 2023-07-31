# Dura-Europos-synagogue-tiles
Dura-Europos Synagogue Ceiling Surveyor 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tile/main.dart';
import 'package:tile/screens/CreateTile/listTile.dart';
import 'package:tile/services/auth.dart';

String about = "   The synagogue in Dura Europos was excavated in the 1930s by the Yale-French Excavations. This 3rd century CE synagogue was adorned with wall paintings and ceiling tiles. The ceiling was decorated with over 400 tiles with over 20 different images decorated onto them. However, only a little more than half were recovered during the excavation and there is no evidence that can help archaeologists determine how they would have been arranged. The tiles have inspired a number of projects on the variety of imagery found across the tile collection and how they would have been viewed. Less than 50 of these tiles are in the Dura Europos collection at the Yale University Art Gallery.\n   This interactive platform allows users to explore the scope of the Dura Europos Synagogue Tiles at YUAG. This project expands the viewing experience of these tiles and gives users the ability to organize them and learn more about the historical significance of the imagery.\n   Click and drag the tiles to arrange them to your own preference, and play around with the order of the images. You can save your work both privately and publicly, as well as explore other users’ contributions in the Public Saves. Click on the menu button in the upper left corner to display the different images found in the tile library. You can learn more about the historical contexts and significance of these images as well as find links to the Yale University Art Gallery website and the Wikidata entry of each tile for additional research.\n\nAll images are from the Yale University Art Gallery collection, https://artgallery.yale.edu/using-images ";

class CreateTile extends StatefulWidget {
  const CreateTile({Key? key}) : super(key: key);
  @override
  _CreateTileState createState() => _CreateTileState();
}

class _CreateTileState extends State<CreateTile>
    with DragFeedback, DragPlaceHolder, DragCompletion {
  final bool _isAlwaysShown = true;
  final bool _showTrackOnHover = false;

  int selectedIndex = 1;
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final AuthService _auth = AuthService();
  final ScrollController _firstController = ScrollController();
  int currentIndex = 1;
  static const List<Color> colors = [Colors.blue, Colors.red, Colors.green];

  // initial order of images
  static List<String> listOfImages = [
    '1_1933.257.jpg',
    '1_1933.265.jpg',
    '1_1933.273.jpg',
    '1_1933.258.jpg',
    '1_1933.268.jpg',
    '1_1938.4881.jpg',
    '2_1933.255.jpg',
    '2_1933.255.jpg',
    '2_1933.269.jpg',
    '2_1933.269.jpg',
    '2_1933.275.jpg',
    '2_1933.275.jpg',
    '2_1933.278.jpg',
    '2_1933.278.jpg',
    '2_1933.267.jpg',
    '2_1933.267.jpg',
    '2_1933.271.jpg',
    '2_1933.271.jpg',
    '2_1933.276.jpg',
    '2_1933.276.jpg',
    '2_1933.281.jpg',
    '2_1933.281.jpg',
    '3_1933.287.jpg',
    '3_1933.287.jpg',
    '3_1933.287.jpg',
    '5_1938.4883.jpg',
    '5_1938.4883.jpg',
    '5_1938.4883.jpg',
    '5_1938.4883.jpg',
    '5_1938.4883.jpg',
    '6_1933.262.jpg',
    '6_1933.262.jpg',
    '6_1933.262.jpg',
    '6_1933.262.jpg',
    '6_1933.262.jpg',
    '6_1933.262.jpg',
  ];

  List<DraggableGridItem> listOfGridItems = [];
  List<String> currentOrder = [];
  int grid_key = 0;

  // Code modified from public example: https://pub.dev/packages/flutter_draggable_gridview/example
  @override
  void initState() {
    listOfGridItems = List.generate(
      listOfImages.length,
      (index) => DraggableGridItem(
          child: _GridItem(image: listOfImages[index]), isDraggable: true),
    );
    currentOrder = listOfImages;
    super.initState();
  }

  bool sideVisible = false;
  double gridWidths(double maxWidth) {
    if (sideVisible == false) {
      return maxWidth - (0.50 * maxWidth);
    } else {
      return maxWidth - (0.50 * maxWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        appBar: AppBar(
          title: Text(projectTitle,
              style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255))),
          elevation: 0.0,
          backgroundColor: Colors.brown,
          leading: IconButton(
            icon: const Icon(Icons.menu,
                color:
                    Color.fromARGB(255, 255, 255, 255)), // set your color here
            onPressed: () => setState(() {
              sideVisible = !sideVisible;
            }),
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.info_rounded),
              label: const Text('About'),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: SingleChildScrollView(
                          child: Center(
                            child: Column(
                              children: [
                                Text(projectTitle),
                                const Text(
                                    "Creators: Claire Campbell, Revant Kantamneni, Brian Li, Pathid Liamtrakoolpanich, Jun Park\n"),
                                Text(
                                  about,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
            ElevatedButton.icon(
                icon: const Icon(Icons.shuffle_rounded),
                label: const Text('Shuffle Grid'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown,
                ),
                onPressed: () {
                  List<String> randomOrder = List.from(listOfImages);
                  randomOrder.shuffle();
                  updateGrid(randomOrder);
                }),
            ElevatedButton.icon(
              icon: const Icon(Icons.saved_search_rounded),
              label: const Text('Public Saves'),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
              ),
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                User user = auth.currentUser!;
                print(user.uid);
                List results = [];
                getsave().then((results1) {
                  for (var item in results1) {
                    if (item[1]["public"] == "public") {
                      results.add(item);
                    }
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        elevation: 16,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              const Center(child: Text('Public Saves')),
                              const SizedBox(height: 20),
                              for (var save in results)
                                _buildRow(context, save[0], save[1]["name"],
                                    save[1]["note"], save[1]["pos"]),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.saved_search_rounded),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
              ),
              label: const Text('Private Saves'),
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                User user = auth.currentUser!;
                print(user.uid);
                List results = [];
                getsave().then((results1) {
                  for (var item in results1) {
                    if (item[1]["user"] == user.uid) {
                      results.add(item);
                    }
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        elevation: 16,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              const Center(child: Text('Private Saves')),
                              const SizedBox(height: 20),
                              for (var save in results)
                                _buildRow(context, save[0], save[1]["name"],
                                    save[1]["note"], save[1]["pos"]),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
              ),
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: () {
                save_task(context, currentOrder);
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
              ),
              icon: const Icon(Icons.person),
              label: const Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, //Center Row contents horizontally,
          crossAxisAlignment:
              CrossAxisAlignment.center, //Center Row contents vertically,
          children: <Widget>[
            if (sideVisible)
              SizedBox(
                width: constraints.maxWidth / 4,
                child: Scrollbar(
                  isAlwaysShown: _isAlwaysShown,
                  showTrackOnHover: _showTrackOnHover,
                  hoverThickness: 30.0,
                  child: StreamBuilder<List<Tile>>(
                      stream: FirebaseFirestore.instance
                          .collection('TileInformation')
                          .snapshots()
                          .map((query) => query.docs
                              .map((map) => Tile.fromMap(map.data()))
                              .toList()),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          // if snapshot has no data this is going to run
                          return Container(
                              alignment: FractionalOffset.center,
                              child: const CircularProgressIndicator());
                        }
                        final tileList = snapshot.data!;
                        return ListView.builder(
                            cacheExtent: 3000,
                            itemExtent: 150,
                            itemCount: tileList.length,
                            itemBuilder: (context, index) {
                              return sideTileImage(index, tileList);
                            });
                      }),
                ),
              ),
            //const Divider(height: 1),
            SizedBox(
              width: 100,
            ),
            SizedBox(
                width: gridWidths(constraints.maxWidth),
                // Code modified from public example: https://pub.dev/packages/flutter_draggable_gridview/example
                child: Scaffold(
                    backgroundColor: const Color.fromARGB(0, 30, 30, 30),
                    body: DraggableGridViewBuilder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      ),
                      children: listOfGridItems,
                      dragCompletion: this,
                      isOnlyLongPress: false,
                      dragFeedback: this,
                      dragPlaceHolder: this,
                      shrinkWrap: true,
                      key: ValueKey(grid_key),
                    ))),
          ],
        ),
      );
    });
  }

  @override
  Widget feedback(List<DraggableGridItem> list, int index) {
    return SizedBox(
      child: list[index].child,
      width: 150,
      height: 150,
    );
  }

  void save_task(BuildContext context, List<String> currentOrder) {
    var nameTECs = <TextEditingController>[];
    var noteTECs = <TextEditingController>[];
    var nameController = TextEditingController();
    var noteController = TextEditingController();
    nameTECs.add(nameController);
    noteTECs.add(noteController);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: Container(
              padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Center(child: Text('Saving')),
                  const SizedBox(height: 20),
                  TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Save Name')),
                  TextField(
                      controller: noteController,
                      decoration: const InputDecoration(labelText: 'Note')),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                      Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel')),
                    const SizedBox(width: 80),
                    ElevatedButton(
                        onPressed: () {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          User user = auth.currentUser!;

                          FirebaseFirestore.instance.collection("saves").add({
                            "name": nameTECs[0].text,
                            "note": noteTECs[0].text,
                            "pos": currentOrder,
                            "user": user.uid,
                            "public": "private"
                          });
                          Navigator.of(context).pop();
                          final snackBar = SnackBar(
                            content: Text('Saved ' + nameTECs[0].text),
                            backgroundColor: (Colors.black12),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: const Text('Save as Private')),
                    const SizedBox(width: 80),
                    ElevatedButton(
                        onPressed: () {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          User user = auth.currentUser!;

                          FirebaseFirestore.instance.collection("saves").add({
                            "name": nameTECs[0].text,
                            "note": noteTECs[0].text,
                            "pos": currentOrder,
                            "user": user.uid,
                            "public": "public"
                          });
                          Navigator.of(context).pop();
                          final snackBar = SnackBar(
                            content: Text('Saved ' + nameTECs[0].text),
                            backgroundColor: (Colors.black12),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: const Text('Save as Public'))
                  ])
                ],
              ),
            ),
          );
        });
  }

  void updateGrid(List<String> updatedOrder) {
    setState(() {
      currentOrder = updatedOrder;
      listOfGridItems = List.generate(
          listOfImages.length,
          (index) => DraggableGridItem(
              child: _GridItem(image: currentOrder[index]), isDraggable: true));
      grid_key++;
    });
  }

  Widget _buildRow(
    BuildContext context,
    String id,
    String name,
    String note,
    List pos,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          Container(
            height: 2,
            color: const Color.fromARGB(255, 30, 30, 30),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12),
                SizedBox(
                  width: 200,
                  child: Flexible(
                    child: Text(name),
                  ),
                ),
                const VerticalDivider(
                  color: Color.fromARGB(255, 30, 30, 30),
                  thickness: 2,
                ),
                SizedBox(
                  width: 500,
                  child: Flexible(
                    child: Text(note),
                  ),
                ),
                const SizedBox(width: 12),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    List<String> updatedOrder = List<String>.from(pos);
                    updateGrid(updatedOrder);
                    Navigator.of(context).pop();
                    final snackBar = SnackBar(
                      content: Text('Loaded ' + name),
                      backgroundColor: (Colors.black12),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Load'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    final collection =
                        FirebaseFirestore.instance.collection('saves');
                    collection
                        .doc(id) // <-- Doc ID to be deleted.
                        .delete() // <-- Delete
                        .then((_) => print('Deleted'))
                        .catchError((error) => print('Delete failed: $error'));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  PlaceHolderWidget placeHolder(List<DraggableGridItem> list, int index) {
    return PlaceHolderWidget(
      child: Container(
        color: Colors.white,
      ),
    );
  }

  @override
  void onDragAccept(List<DraggableGridItem> list) {
    currentOrder = List.generate(
        list.length, (index) => (list[index].child as _GridItem).image);
    print(currentOrder);
  }
}

// Code modified from public example: https://pub.dev/packages/flutter_draggable_gridview/example

class _GridItem extends StatelessWidget {
  const _GridItem({required this.image, Key? key}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Image.asset(
        "assets/" + image,
        fit: BoxFit.cover,
      ),
    );
  }
}

class FireStoreDataBase {
  String? downloadURL;

  Future getData(url) async {
    try {
      await downloadURLExample(url);
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample(String url) async {
    downloadURL =
        await FirebaseStorage.instance.refFromURL(url).getDownloadURL();
  }
}

Future<List> getsave() async {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('saves');
  QuerySnapshot querySnapshot = await _collectionRef.get();

  final all_data =
      querySnapshot.docs.map((doc) => [doc.id, doc.data()]).toList();
  print(all_data);
  return all_data;
}
