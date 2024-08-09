class TaxOffice {
  final int taxOfficeId;
  final int cityId;
  final String? city;
  final String? district;
  final String? office;

  TaxOffice({
    required this.taxOfficeId,
    required this.cityId,
    this.city,
    this.district,
    this.office,
  });

  // JSON'dan TaxOffice nesnesi oluşturma
  factory TaxOffice.fromJson(Map<String, dynamic> json) {
    return TaxOffice(
      taxOfficeId: json['taxOfficeId'],
      cityId: json['cityId'],
      city: json['city'],
      district: json['district'],
      office: json['office'],
    );
  }

  // TaxOffice nesnesini JSON formatına çevirme
  Map<String, dynamic> toJson() {
    return {
      'taxOfficeId': taxOfficeId,
      'cityId': cityId,
      'city': city,
      'district': district,
      'office': office,
    };
  }
}
