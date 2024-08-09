class endpoints {
  endpoints._();
  static const String baseUrl = "http://stajyerapp.runasp.net/api";

  static const String login = '$baseUrl/User/Login';

  static const String registerUrl = '$baseUrl/User/Register';
  static const String homelistadv = '$baseUrl/Advert/ListAllActiveAdverts';
  static const String CompanyListUrl = '$baseUrl/Company/ListAllCompanies';
  static const String GetCompanyByIdUrl = '$baseUrl/Company/GetCompanyByCompanyId';
  static const String Apply = '$baseUrl/Application/UserApplyAdvert';

  static const String getUserByIdUrl = '$baseUrl/User/GetUser';

  static const String UserSaveAndDeleteAdvert ='$baseUrl/Advert/UserSaveDeleteAdvert'; 

  static const String checkApply ='http://stajyerapp.runasp.net/api/Advert/GetUserIsApplied'; 


  static const String getAdvByCompIdUrl = '$baseUrl/Advert/ListCompanyAdverts';
  static const String UpdateUserUrl = '$baseUrl/User/UpdateUser'; //kullanıcı bilgilerini guncelle

  static const String addProjectUrl = '$baseUrl/Project/AddProject';
  static const String GetProjectByUserIdUrl =
      '$baseUrl/Project/ListUserProjects';

  static const addCertificateUrl = '$baseUrl/Certificates/AddCertificate';
  static const GetCertifiaceByUserIdUrl =
      '$baseUrl/Certificates/ListUserCertificates';

  static const String GetExperienceByUserIdUrl =
      '$baseUrl/Experience/ListUserExperiences';
  static const String addExperienceUrl = '$baseUrl/Experience/AddExperience';
  static const String deleteExperienceUrl =
      '$baseUrl/Experience/DeleteExperience';

  static const String addEducationUrl = '$baseUrl/Education/AddEducation';
  static const String GetEducationByUserIdUrl =
      '$baseUrl/Education/ListUserEducations';

  static const int receiveTimeout =
      15000; // sunucudan yanıtın alınması gereken max süre
  static const int connectionTimeout = 15000; //sunucuya bağlanma süresi
}
