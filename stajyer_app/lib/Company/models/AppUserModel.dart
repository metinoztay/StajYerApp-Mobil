import 'package:stajyer_app/Company/models/ApplicationModel.dart';
import 'package:stajyer_app/User/models/CertificateModel.dart';
import 'package:stajyer_app/User/models/EducationModel.dart';
import 'package:stajyer_app/User/models/ExperienceModel.dart';
import 'package:stajyer_app/User/models/ProjectModel.dart';

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
  final List<ProjectModel> projects;
  final List<EducationModel> educations;
  final List<ExperienceModel> experiences;
  String? ulinkedin;
  String? ucv;
  String? ugithub;
  String? udesc;

  AppUserModel(
      {required this.userId,
      required this.uname,
      required this.usurname,
      required this.uemail,
      this.uphone,
      required this.ubirthdate,
      required this.ugender,
      this.uprofilephoto,
      required this.applications,
      required this.certificates,
      required this.projects,
      required this.educations,
      required this.experiences,
      this.ulinkedin,
      this.ucv,
      this.ugithub,
      this.udesc});

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    var list = json['applications']['\$values'] as List;
    List<ApplicationModel> applicationsList =
        list.map((i) => ApplicationModel.fromJson(i)).toList();
    var listCert = json['certificates']['\$values'] as List;
    List<CertificateModel> certificatesList =
        listCert.map((i) => CertificateModel.fromJson(i)).toList();
    var listProject = json['projects']['\$values'] as List;
    List<ProjectModel> projectsList =
        listProject.map((i) => ProjectModel.fromJson(i)).toList();

    var listEducation = json['educations']['\$values'] as List;
    List<EducationModel> educationsList =
        listEducation.map((i) => EducationModel.fromJson(i)).toList();

    var listExperience = json['experiences']['\$values'] as List;
    List<ExperienceModel> experiencesList =
        listExperience.map((i) => ExperienceModel.fromJson(i)).toList();

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
        certificates: certificatesList,
        projects: projectsList,
        educations: educationsList,
        experiences: experiencesList,
        ulinkedin: json['ulinkedin'],
        ucv: json['ucv'],
        ugithub: json['ugithub'],
        udesc: json['udesc']);
  }
}
