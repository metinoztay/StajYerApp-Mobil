class Endpoints {
  Endpoints._();
  static const String baseUrl = "http://stajyerapp.runasp.net/api";
  static const String companyUserRegisterUrl = '$baseUrl/CompanyUser/Register';
  static const String ListCityUrl = '$baseUrl/City/ListCities';
  static const String ListTaxOfficeByCityIdUrl = '$baseUrl/City/ListTaxOffices';
  static const String ListAdvertByCompanyUserId =
      '$baseUrl/Advert/ListAdvertsByCompanyUserId';
}
