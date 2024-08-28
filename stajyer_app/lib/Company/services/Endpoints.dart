class Endpoints {
  Endpoints._();
  static const String baseUrl = "http://stajyerapp.runasp.net/api";
  static const String companyUserRegisterUrl = '$baseUrl/CompanyUser/Register';
  static const String ListCityUrl = '$baseUrl/City/ListCities';
  static const String ListTaxOfficeByCityIdUrl = '$baseUrl/City/ListTaxOffices';
  static const String ListAdvertByCompanyUserId =
      '$baseUrl/Advert/ListAdvertsByCompanyUserId';

  static const String complogin = '$baseUrl/CompanyUser/Login';
  static const String GetCompanyByCompanyUserId =
      '$baseUrl/CompanyUser/GetCompanyInformations';
  static const String CompanyAddAdvert = '$baseUrl/Advert/CompUserAddAdvert';
  static const String UpdateAdvUrl = '$baseUrl/Advert/UpdateAdvert';
  static const String AddCompany = '$baseUrl/Company/AddCompany';
  static const String DeleteAdvertUrl = '$baseUrl/Advert/DeleteAdvert';
  static const String UpdateCompanyUrl = '$baseUrl/Company/UpdateCompany';
  static const String ListAdvertApplications =
      '$baseUrl/Application/ListAdvertsApplications';
  static const String ApplicationsByAdvId =
      '$baseUrl/Application/ListAdvertsApplications';
  static const String CompForgotPasswordUrl =
      '$baseUrl/CompanyUser/ForgotPassword';
  static const String CompResetPasswordUrl =
      '$baseUrl/CompanyUser/ResetPassword';
}
