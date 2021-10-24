import 'package:flutter_nautas_app/models/psi_powers.dart';

class Psychonaut {
  String gender = '';
  String img = '';
  String sId = '';
  String name = '';
  List<PsiPowers> psiPowers = [];
  int iV = 0;

  Psychonaut(
      {required gender, required this.img, required this.sId, required this.name, required this.psiPowers, required this.iV});

  Psychonaut.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    img = json['img'];
    sId = json['_id'];
    name = json['name'];
    if (json['psiPowers'] != null) {
      psiPowers = <PsiPowers>[];
      json['psiPowers'].forEach((v) {
        psiPowers.add(PsiPowers.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['img'] = img;
    data['_id'] = sId;
    data['name'] = name;
    data['psiPowers'] = psiPowers.map((v) => v.toJson()).toList();
    data['__v'] = iV;
    return data;
  }
}