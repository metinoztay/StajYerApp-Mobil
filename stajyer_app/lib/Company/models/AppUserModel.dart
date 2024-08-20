import 'package:stajyer_app/Company/models/ApplicationModel.dart';
import 'package:stajyer_app/User/models/CertificateModel.dart';

class AppUserModel {
  final int userId;
  final String uname;
  final String usurname;
  final String uemail;
  final String? uphone;
  final String ubirthdate;
  final bool ugender;
  final String? uprofilephoto;
  final List<ApplicationModel> applications;
  final List<CertificateModel> certificates;

  AppUserModel({
    required this.userId,
    required this.uname,
    required this.usurname,
    required this.uemail,
    this.uphone,
    required this.ubirthdate,
    required this.ugender,
    this.uprofilephoto,
    required this.applications,
    required this.certificates,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    var list = json['applications']['\$values'] as List;
    List<ApplicationModel> applicationsList =
        list.map((i) => ApplicationModel.fromJson(i)).toList();
    var listCert = json['certificates']['\$values'] as List;
    List<CertificateModel> certificatesList =
        listCert.map((i) => CertificateModel.fromJson(i)).toList();

    return AppUserModel(
        userId: json['userId'],
        uname: json['uname'],
        usurname: json['usurname'],
        uemail: json['uemail'],
        uphone: json['uphone'],
        ubirthdate: json['ubirthdate'],
        ugender: json['ugender'],
        uprofilephoto: json['uprofilephoto'],
        applications: applicationsList,
        certificates: certificatesList);
  }
}
