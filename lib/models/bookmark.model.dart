class BookmarkList {
  List<Bookmark>? bookmarkList;

  BookmarkList({required this.bookmarkList});

  BookmarkList.fromJson(Map<String, dynamic> json) {
    if (json['bookmarkList'] != null) {
      bookmarkList = <Bookmark>[];
      json['bookmarkList'].forEach((v) {
        bookmarkList!.add(Bookmark.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookmarkList'] = bookmarkList!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Bookmark {
  String? ayahNo;
  String? suraId;
  String? tname;
  String? ename;

  Bookmark(
      {required this.ayahNo,
      required this.suraId,
      required this.tname,
      required this.ename});

  Bookmark.fromJson(Map<String, dynamic> json) {
    ayahNo = json['ayahNo'];
    suraId = json['suraId'];
    tname = json['tname'];
    ename = json['ename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ayahNo'] = ayahNo;
    data['suraId'] = suraId;
    data['tname'] = tname;
    data['ename'] = ename;
    return data;
  }
}
