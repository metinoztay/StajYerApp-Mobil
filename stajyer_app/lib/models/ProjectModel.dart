class ProjectModel {
  int? proId;
  int? userId;
  String? proName;
  String? proDesc;
  String? proGithub;

  ProjectModel({
    this.proId,
    this.userId,
    this.proName,
    this.proDesc,
    this.proGithub,
  });

  ProjectModel.fromJson(Map<String, dynamic> json) {
    proId = json['proId'];
    userId = json['userId'];
    proName = json['proName'];
    proDesc = json['proDesc'];
    proGithub = json['proGithub'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['proId'] = this.proId ??
        0; // `proId` gönderilmesi gerekiyorsa, null ise 0 gönderin
    data['userId'] = this.userId;
    data['proName'] = this.proName;
    data['proDesc'] = this.proDesc;
    data['proGithub'] = this.proGithub;
    return data;
  }

  static List<ProjectModel> fromJsonList(Map<String, dynamic> json) {
    if (json.containsKey('\$values')) {
      List<dynamic> values = json['\$values'];
      return values.map((item) => ProjectModel.fromJson(item)).toList();
    } else {
      throw Exception('JSON formatı beklenmedik bir şekilde: $json');
    }
  }
}