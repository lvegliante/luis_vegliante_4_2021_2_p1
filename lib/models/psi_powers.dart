class PsiPowers {
  String description = '';
  String img = '';
  String sId = '';
  String name = '';

  PsiPowers({required description, required img, required sId, required name});

  PsiPowers.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    img = json['img'];
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = description;
    data['img'] = img;
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}