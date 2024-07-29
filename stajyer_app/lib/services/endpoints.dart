class Endpoints {
  Endpoints._(); //sınfın dışarıdan örneklenmesini engellemek için
  static const String baseUrl = "http://stajyerapp.runasp.net/api";

  static const String login = '$baseUrl/User/Login';

  

  static const int receiveTimeout =
      15000; // sunucudan yanıtın alınması gereken max süre
  static const int connectionTimeout = 15000; //sunucuya bağlanma süresi
}