class AudioModel {
  late String name;
  late String path;
  late bool isSaved;
  String? succes;

  AudioModel({
    required this.name,
    this.succes,
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

  @override
  String toString() {
    // TODO: implement toString
    return path.toString();
  }

  bool operator ==(Object object) {
    return (object is AudioModel) &&
        (object.name == name) &&
        (object.path == path);
  }
}
