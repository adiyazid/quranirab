// To parse this JSON data, do
//
//     final sliceData = sliceDataFromJson(jsonString);

import 'dart:convert';

SliceDataList sliceDataFromJson(String str) => SliceDataList.fromJson(json.decode(str));

String sliceDataToJson(SliceDataList data) => json.encode(data.toJson());

class SliceDataList {
  SliceDataList({
    required this.slicingData,
  });

  List<SlicingData> slicingData;

  factory SliceDataList.fromJson(Map<String, dynamic> json) => SliceDataList(
    slicingData: List<SlicingData>.from(json["slicing_data"].map((x) => SlicingData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "slicing_data": List<dynamic>.from(slicingData.map((x) => x.toJson())),
  };
}

class SlicingData {
  SlicingData({
    required this.start,
    required this.end,
    required this.wordId,
  });

  int start;
  int end;
  int? wordId;

  factory SlicingData.fromJson(Map<String, dynamic> json) => SlicingData(
    start: json["start"],
    end: json["end"],
    wordId: json["word_id"]??0,
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
    "word_id": wordId,
  };
}
