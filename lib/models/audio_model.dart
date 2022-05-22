class AudioModel {
  late String name;
  late String path;
  late bool isSaved;

  AudioModel({
    required this.name,
    required this.path,
    this.isSaved = false,
  });

  toJson() {
    return {"name": name, "path": path, "isSaved": isSaved};
  }

  AudioModel.fromJson(Map<dynamic, dynamic> map) {
    name = map["name"]!;
    path = map["path"]!;
    isSaved = map["isSaved"];
  }
}
