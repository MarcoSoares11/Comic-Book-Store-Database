import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_book_store/config/global_theming.dart';
import 'package:comic_book_store/domain/user/firebase_auth_service.dart';
import 'package:comic_book_store/providers/local_storage_provider.dart';
import 'package:comic_book_store/widgets/home_page_widgets/book_title_list_view.dart';
import 'package:comic_book_store/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controls the text when adding new book
  TextEditingController controller = new TextEditingController(text: "");

  /// Animates the [child] widget from [snapshot].
  ///
  /// Responsible for animating a transition in between no books in the
  /// database and when a book is added.
  ///
  /// Adds a fade in transition.
  Widget switcherChild(AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: snapshot.data.data() == null || snapshot.data.data().length == 0
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
    // Initializes the providers.
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
        // Make sure the login is finished
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
              onPressed: () {
                showModal(
                  context: context,
                  builder: (_) => StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text("Add a book"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              autocorrect: false,
                              onChanged: (text) {
                                print(controller.text);
                                setState(() {});
                              },
                              controller: controller,
                              decoration: InputDecoration(
                                labelText: "Name of your book",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        actions: [
                          PreferenceBuilder(
                            preference: localStorageProvider.uid,
                            builder: (context, uid) {
                              return FlatButton(
                                onPressed: controller.text == ""
                                    ? null
                                    : () async {
                                        await FirebaseFirestore.instance
                                            .collection('store')
                                            .doc(uid)
                                            .update({
                                          "book_titles": FieldValue.arrayUnion([
                                            controller.text,
                                          ])
                                        });
                                        controller.clear();
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop('dialog');
                                      },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                splashColor: Colors.black12,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.library_add,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Add book",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                );
              },
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
                      if (snapshot.hasData &&
                          snapshot.data.data()["book_titles"] != []) {
                        return AnimatedSwitcher(
                          duration: Duration(
                            milliseconds: 400,
                          ),
                          child: switcherChild(snapshot),
                        );
                      } else {
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
                      }
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
