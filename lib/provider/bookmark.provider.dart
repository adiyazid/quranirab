import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quranirab/models/bookmark.model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BookMarkProvider extends ChangeNotifier {
  List<Bookmark> bookmarkList = <Bookmark>[];

  Future<void> getList() async {
    //   GetStorage().remove('bookmarkList');
    var jsonData = GetStorage().read('bookmarkList') ?? 'No data';
    if (jsonData != 'No data') {
      var jsonList = BookmarkList.fromJson(jsonData);
      bookmarkList = jsonList.bookmarkList!;
    }
  }

  Future<void> addtoBookmark(BuildContext context, String ayahno, String suraId,
      String tname, String ename, List pages) async {
    print('adding to bookmark..');
    var newData = Bookmark(
        ayahNo: ayahno,
        suraId: suraId,
        tname: tname,
        ename: ename,
        pages: pages);
    if (bookmarkList.isEmpty) {
      bookmarkList.add(newData);
      showTopSnackBar(
          context,
          CustomSnackBar.success(
              message: AppLocalizations.of(context)!.bookmarkAdded));
    } else {
      bool duplicate =
          bookmarkList.any((element) => element.ayahNo == newData.ayahNo);
      if (!duplicate) {
        bookmarkList.add(newData);
        showTopSnackBar(
            context,
            CustomSnackBar.success(
                message: AppLocalizations.of(context)!.bookmarkAdded));
      } else {
        showTopSnackBar(
            context,
            CustomSnackBar.error(
                message: AppLocalizations.of(context)!.bookmarkError));
      }
    }
    notifyListeners();
    saveToLocal();
  }

  void saveToLocal() {
    var jsonData = BookmarkList(bookmarkList: bookmarkList).toJson();
    GetStorage().write('bookmarkList', jsonData);
    notifyListeners();
  }

  void deleteAll() {
    GetStorage().remove('bookmarkList');
    bookmarkList.clear();
    notifyListeners();
  }
}
