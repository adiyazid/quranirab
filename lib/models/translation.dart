class TranslationModel {
  String created_at;
  String id;
  String language_id;
  String name;
  String translator;
  String updated_at;
  TranslationModel(
      {required this.created_at,
      required this.id,
      required this.name,
      required this.language_id,
      required this.translator,
      required this.updated_at});

  TranslationModel.fromJson(Map<String, dynamic> parsedJSON)
      : name = parsedJSON['name'],
        created_at = parsedJSON['created_at'],
        id = parsedJSON['id'],
        language_id = parsedJSON['id'],
        translator = parsedJSON['translator'],
        updated_at = parsedJSON['updated_at'];
}
