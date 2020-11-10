import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_book_store/config/global_theming.dart';
import 'package:comic_book_store/domain/user/firebase_auth_service.dart';
import 'package:comic_book_store/providers/local_storage_provider.dart';
import 'package:comic_book_store/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget switcherChild(AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: snapshot.data.data() == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book,
                      color: ComicBookStoreTheming().secondary,
                      size: 120,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Add a book to get started",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: BookTitlesListView(
                        snapshot: snapshot,
                      ),
                    ),
                  ],
                ),
              ),
      );
    } else {
      return Center();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localStorageProvider = Provider.of<LocalStorageProvider>(
      context,
      listen: false,
    );
    final firebaseAuthService = Provider.of<FirebaseAuthService>(
      context,
      listen: false,
    );
    return PreferenceBuilder<bool>(
      preference: localStorageProvider.finishedLogin,
      builder: (context, finishedLogin) {
        if (finishedLogin == true) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Mr Wach's Comic Book Store",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              backgroundColor: ComicBookStoreTheming().accent,
              elevation: 10,
            ),
            floatingActionButton: RaisedButton(
              onPressed: () {},
              elevation: 3.0,
              padding: EdgeInsets.all(
                10.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              color: ComicBookStoreTheming().secondary,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: 28,
                  ),
                  Text(
                    "Add a book",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            body: PreferenceBuilder(
              preference: localStorageProvider.uid,
              builder: (context, uid) {
                if (uid != null) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('store')
                        .doc(uid)
                        .snapshots(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot,
                    ) {
                      return AnimatedSwitcher(
                        duration: Duration(
                          milliseconds: 400,
                        ),
                        child: switcherChild(snapshot),
                      );
                    },
                  );
                }
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Finished",
              ),
              actions: [
                FlatButton(
                  onPressed: () async {
                    await firebaseAuthService.signOutWithGoogle();
                  },
                  child: Text(
                    "Logout",
                  ),
                )
              ],
            ),
            body: ComicBookStoreProgressIndicator(),
          );
        }
      },
    );
  }
}

class BookTitlesListView extends StatelessWidget {
  final AsyncSnapshot<DocumentSnapshot> snapshot;

  const BookTitlesListView({
    Key key,
    @required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius mainRadius = BorderRadius.circular(15);
    if (snapshot.data.data().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              color: ComicBookStoreTheming().secondary,
              size: 120,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Add a book to get started",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: false,
        itemCount: snapshot.data.data()["book_titles"].length,
        itemBuilder: (context, int index) {
          return Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: mainRadius,
            ),
            child: Material(
              elevation: 4.0,
              borderRadius: mainRadius,
              child: Container(
                decoration: BoxDecoration(
                  color: ComicBookStoreTheming().accent,
                  borderRadius: mainRadius,
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: mainRadius,
                  child: InkWell(
                    onTap: () {
                      showModal(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: mainRadius,
                            ),
                            title: Text("Edit"),
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    DocumentSnapshot _titlesDoc =
                                        await FirebaseFirestore.instance
                                            .collection('store')
                                            .doc(snapshot.data.id)
                                            .get();
                                    print(_titlesDoc
                                        .data()["book_titles"]
                                        .length);
                                    if (_titlesDoc
                                            .data()["book_titles"]
                                            .length ==
                                        1) {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop('dialog');
                                      await FirebaseFirestore.instance
                                          .collection('store')
                                          .doc(snapshot.data.id)
                                          .update({
                                        "book_titles": FieldValue.delete()
                                      });
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection('store')
                                          .doc(snapshot.data.id)
                                          .update({
                                        "book_titles": FieldValue.arrayRemove(
                                          [
                                            _titlesDoc.data()["book_titles"]
                                                [index],
                                          ],
                                        )
                                      });
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop('dialog');
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        "Delete",
                                      ),
                                    ],
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        "Edit title",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    splashColor: Colors.white,
                    borderRadius: mainRadius,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: mainRadius,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book,
                            size: 30,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "${snapshot.data.data()["book_titles"][index]}",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
