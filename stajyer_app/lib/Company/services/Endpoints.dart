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
}
