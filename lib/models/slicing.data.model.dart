// To parse this JSON data, do
//
//     final sliceData = sliceDataFromJson(jsonString);

import 'dart:convert';

SliceData sliceDataFromJson(String str) => SliceData.fromJson(json.decode(str));

String sliceDataToJson(SliceData data) => json.encode(data.toJson());

class SliceData {
  SliceData({
    required this.slicingData,
  });

  List<SlicingDatum> slicingData;

  factory SliceData.fromJson(Map<String, dynamic> json) => SliceData(
    slicingData: List<SlicingDatum>.from(json["slicing_data"].map((x) => SlicingDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "slicing_data": List<dynamic>.from(slicingData.map((x) => x.toJson())),
  };
}

class SlicingDatum {
  SlicingDatum({
    required this.start,
    required this.end,
    required this.wordId,
  });

  int start;
  int end;
  int wordId;

  factory SlicingDatum.fromJson(Map<String, dynamic> json) => SlicingDatum(
    start: json["start"],
    end: json["end"],
    wordId: json["word_id"],
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
    "word_id": wordId,
  };
}
