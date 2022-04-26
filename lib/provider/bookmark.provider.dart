import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quranirab/models/bookmark.model.dart';

class BookMarkProvider extends ChangeNotifier {
  List<Bookmark> bookmarkList = <Bookmark>[];

  Future<void> getList() async {
    // GetStorage().remove('bookmarkList');
    var jsonData = GetStorage().read('bookmarkList') ?? 'No data';
    print(jsonData);
    if (jsonData != 'No data') {
      var jsonList = BookmarkList.fromJson(jsonData);
      bookmarkList = jsonList.bookmarkList!;
    }
  }

  Future<void> addtoBookmark(
      String ayahno, String suraId, String tname, String ename) async {
    print('adding to bookmark..');
    if (bookmarkList.isEmpty) {
      bookmarkList.add(
          Bookmark(ayahNo: ayahno, suraId: suraId, tname: tname, ename: ename));
      notifyListeners();
      var jsonData = BookmarkList(bookmarkList: bookmarkList).toJson();
      GetStorage().write('bookmarkList', jsonData);
    }
    for (int i = 0; i < bookmarkList.length; i++) {
      if (bookmarkList[i].ayahNo == ayahno) {
        print('ERROR: duplicate bookmark');
      } else {
        bookmarkList.add(Bookmark(
            ayahNo: ayahno, suraId: suraId, tname: tname, ename: ename));
        notifyListeners();
        var jsonData = BookmarkList(bookmarkList: bookmarkList).toJson();
        GetStorage().write('bookmarkList', jsonData);
      }
    }
    getList();
  }
}
