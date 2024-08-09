import 'package:stajyer_app/Company/models/TaxOfiice.dart';

class City {
  final int cityId;
  final String? cityName;
  final List<TaxOffice>? taxOffices;

  City({
    required this.cityId,
    this.cityName,
    this.taxOffices,
  });

  // JSON'dan City nesnesi oluşturma
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['cityId'],
      cityName: json['cityName'],
      taxOffices: json['taxOffices']?['\$values'] != null
          ? (json['taxOffices']['\$values'] as List)
              .map((i) => TaxOffice.fromJson(i))
              .toList()
          : null,
    );
  }

  // City nesnesini JSON formatına çevirme
  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'cityName': cityName,
      'taxOffices': {
        '\$values': taxOffices?.map((e) => e.toJson()).toList(),
      },
    };
  }

  @override
  String toString() {
    return cityName ?? 'Unknown City';
  }
}
