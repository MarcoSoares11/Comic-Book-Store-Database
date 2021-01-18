import 'package:animations/animations.dart';
import 'package:comic_book_store/config/global_theming.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookTitlesListView extends StatelessWidget {
  final AsyncSnapshot<DocumentSnapshot> snapshot;

  const BookTitlesListView({
    Key key,
    @required this.snapshot,
  }) : super(key: key);

  /// Deletes a book from the database.
  ///
  /// If the array length is only 1, it will delete the whole field that
  /// stores the array values.
  ///
  /// If the array length is greater than 1, it will delete the specific index
  /// of the array.
  Future<void> deleteBook(
    BuildContext context,
    int index,
  ) async {
    DocumentSnapshot _titlesDoc = await FirebaseFirestore.instance
        .collection('store')
        .doc(snapshot.data.id)
        .get();
    print(_titlesDoc.data()["book_titles"].length);
    if (_titlesDoc.data()["book_titles"].length == 1) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop('dialog');
      await FirebaseFirestore.instance
          .collection('store')
          .doc(snapshot.data.id)
          .update({
        "book_titles": FieldValue.delete(),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('store')
          .doc(snapshot.data.id)
          .update({
        "book_titles": FieldValue.arrayRemove([
          _titlesDoc.data()["book_titles"][index],
        ])
      });
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop('dialog');
    }
  }

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
                                    await deleteBook(context, index);
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
