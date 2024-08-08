class UserModel {
  int? userId;
  String? uname;
  String? usurname;
  String? uemail;
  String? upassword;
  String? uphone;
  String? ubirthdate;
  bool? ugender;
  String? ulinkedin;
  String? ucv;
  String? ugithub;
  String? udesc;
  String? uprofilephoto;
  bool? uisactive;
  bool? uisEmailVerified;
  bool? uisPhoneVerified;

  // Varsayılan değerleri burada tanımlayabilirsiniz
  static const String defaultGithub = 'Github adresinizi giriniz';
  static const String defaultLinkedin = 'Linkedin adresinizi giriniz';
  static const String defaultCv = 'Cv linkinizi giriniz';
  static const String defaultDesc = 'Kendinizi tanıtınız';
  static const String defaultPhone =
      'Şirketlerin siz ulaşabilmesi için telefon numarası girmelisiniz.';

  UserModel({
    this.userId,
    this.uname,
    this.usurname,
    this.uemail,
    this.upassword,
    this.uphone = defaultPhone,
    this.ubirthdate,
    this.ugender,
    this.ulinkedin = defaultLinkedin, // Varsayılan değer
    this.ucv = defaultCv,
    this.ugithub = defaultGithub, // Varsayılan değer
    this.udesc = defaultDesc,
    this.uprofilephoto,
    this.uisactive,
    this.uisEmailVerified,
    this.uisPhoneVerified,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    uname = json['uname'];
    usurname = json['usurname'];
    uemail = json['uemail'];
    upassword = json['upassword'];
    uphone = json['uphone'] ?? defaultPhone;
    ubirthdate = json['ubirthdate'];
    ugender = json['ugender'];
    ulinkedin = json['ulinkedin'] ?? defaultLinkedin;
    ucv = json['ucv'] ?? defaultCv;
    // Varsayılan değer burada kontrol edilebilir
    ugithub = json['ugithub'] ?? defaultGithub;
    udesc = json['udesc'] ?? defaultDesc;
    uprofilephoto = json['uprofilephoto'];
    uisactive = json['uisactive'];
    uisEmailVerified = json['uisEmailVerified'];
    uisPhoneVerified = json['uisPhoneVerified'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['uname'] = uname;
    data['usurname'] = usurname;
    data['uemail'] = uemail;
    data['upassword'] = upassword;
    data['uphone'] = uphone;
    data['ubirthdate'] = ubirthdate;
    data['ugender'] = ugender;
    data['ulinkedin'] = ulinkedin;
    data['ucv'] = ucv;
    data['ugithub'] = ugithub;
    data['udesc'] = udesc;
    data['uprofilephoto'] = uprofilephoto;
    data['uisactive'] = uisactive;
    data['uisEmailVerified'] = uisEmailVerified;
    data['uisPhoneVerified'] = uisPhoneVerified;
    return data;
  }
}