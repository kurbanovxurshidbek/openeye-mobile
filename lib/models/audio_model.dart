class AudioModel {
  late String name;
  late String path;
  late bool isSaved;

  AudioModel({
    required this.name,
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
