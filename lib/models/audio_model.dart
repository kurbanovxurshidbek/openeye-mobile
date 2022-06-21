class AudioModel {
  late String name;
  late String path;
  late bool isSaved;
  int? index;

  AudioModel({
    required this.name,
    this.index,
    required this.path,
    this.isSaved = false,
  });

  Map toJson() {
    return {"name": name, "path": path, "isSaved": true};
  }

  AudioModel.fromJson(Map<dynamic, dynamic> map) {
    name = map["name"]!;
    path = map["path"]!;
    isSaved = map["isSaved"];
  }

  bool operator ==(Object object) {
    return (object is AudioModel) && (object.name == name);
  }
}
