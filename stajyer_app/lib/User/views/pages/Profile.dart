import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/models/UserModel.dart';
import 'package:stajyer_app/User/services/api/UserService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/AddProje.dart';
import 'package:stajyer_app/User/views/components/UplodaPhotoScreen.dart';
import 'package:stajyer_app/User/views/components/UserCertificateWidget.dart';
import 'package:stajyer_app/User/views/components/UserEducationWidget.dart';
import 'package:stajyer_app/User/views/components/UserExperienceWidget.dart';
import 'package:stajyer_app/User/views/components/UserProjectWidget.dart';
import 'package:stajyer_app/User/views/pages/loginPage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? user;
  bool isLoading = true;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      try {
        UserService userService = UserService();
        UserModel fetchedUser = await userService.getUserById(userId);
        setState(() {
          user = fetchedUser;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kullanıcı bilgileri alınamadı'),
          ),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kullanıcı ID bulunamadı'),
        ),
      );
    }
  }

  Future<void> _updateProfilePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? userId = prefs.getInt('userId');

        if (userId != null) {
          UserService userService = UserService();

          String? photoUrl =
              await userService.uploadUserPhoto(user!.userId ?? 22, file);

          // Kullanıcı bilgilerini güncelleyin
          Map<String, dynamic> updatedData = {
            'userId': userId,
            'uprofilephoto': photoUrl,
          };

          await userService.updateUser(userId, updatedData);
          _getUserInfo();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profil fotoğrafınız başarıyla güncellendi.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kullanıcı ID bulunamadı')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fotoğraf güncellenirken bir hata oluştu: $e'),
          ),
        );
      }
    }
  }

  Future<void> _logoOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void _editInfo(BuildContext context, String title, String initialValue,
      String fieldName) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    String? errorText;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Güncelle", style: TextStyle(color: ilanCard)),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  keyboardType: fieldName == "uemail"
                      ? TextInputType.emailAddress
                      : fieldName == "uphone"
                          ? TextInputType.phone
                          : TextInputType.text,
                  decoration: InputDecoration(
                    labelText: title,
                    errorText: errorText,
                  ),
                  maxLines: fieldName == "udesc"
                      ? 8
                      : 1, // "udesc" için daha fazla satır
                  minLines: fieldName == "udesc"
                      ? 4
                      : 1, // Minimum satır sayısını ayarl
                  validator: (value) {
                    if (fieldName == "uemail" &&
                        (value == null || !isValidEmail(value))) {
                      return 'Geçerli bir e-posta adresi girin.';
                    }
                    if (fieldName == "uphone" &&
                        (value == null || !isValidPhoneNumber(value))) {
                      return 'Telefon numarası 11 haneli olmalıdır.';
                    }
                    return null;
                  },
                ),
                if (errorText != null) // Hata mesajı varsa göster
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorText!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ilanCard,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                // Formun doğruluğunu kontrol et
                if (!_formKey.currentState!.validate()) {
                  return; // Eğer form geçerli değilse işlemi durdur
                }

                final newValue = controller.text;

                // Hata mesajlarını sıfırla
                errorText = null;

                SharedPreferences prefs = await SharedPreferences.getInstance();
                int? userId = prefs.getInt('userId');

                if (userId != null) {
                  UserService userService = UserService();

                  try {
                    UserModel currentUser =
                        await userService.getUserById(userId);

                    Map<String, dynamic> updatedData = {
                      'userId': userId,
                      'uname':
                          fieldName == "uname" ? newValue : currentUser.uname,
                      'usurname': fieldName == "usurname"
                          ? newValue
                          : currentUser.usurname,
                      'uemail':
                          fieldName == "uemail" ? newValue : currentUser.uemail,
                      'upassword': fieldName == "upassword"
                          ? newValue
                          : currentUser.upassword,
                      'uphone':
                          fieldName == "uphone" ? newValue : currentUser.uphone,
                      'ubirthdate': fieldName == "ubirthdate"
                          ? newValue
                          : currentUser.ubirthdate,
                      'ugender': currentUser.ugender,
                      'ulinkedin': fieldName == "ulinkedin"
                          ? newValue
                          : currentUser.ulinkedin,
                      'ucv': fieldName == "ucv" ? newValue : currentUser.ucv,
                      'ugithub': fieldName == "ugithub"
                          ? newValue
                          : currentUser.ugithub,
                      'udesc':
                          fieldName == "udesc" ? newValue : currentUser.udesc,
                      'uprofilephoto': currentUser.uprofilephoto,
                      'uisactive': currentUser.uisactive,
                      'uisEmailVerified': currentUser.uisEmailVerified,
                      'uisPhoneVerified': currentUser.uisPhoneVerified,
                    };

                    await userService.updateUser(userId, updatedData);

                    _getUserInfo();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bilgileriniz başarıyla güncellendi.'),
                      ),
                    );

                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Güncelleme sırasında bir hata oluştu: $e'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kullanıcı ID bulunamadı')),
                  );
                }
              },
              child: Text(
                "Kaydet",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("İptal", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _changePassword(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    String? oldPasswordError;
    String? newPasswordError;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Şifre Değiştir", style: TextStyle(color: ilanCard)),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: oldPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Eski Şifre", errorText: oldPasswordError),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Eski şifre gereklidir';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Yeni Şifre", errorText: newPasswordError),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Yeni şifre gereklidir';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration:
                          InputDecoration(labelText: "Yeni Şifre Tekrar"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Yeni şifre tekrar gereklidir';
                        }
                        if (value != newPasswordController.text) {
                          return 'Yeni şifreler eşleşmiyor';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ilanCard,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    setState(() {
                      oldPasswordError = null;
                      newPasswordError = null;
                    });
                    if (_formKey.currentState?.validate() ?? false) {
                      final oldPassword = oldPasswordController.text;
                      final newPassword = newPasswordController.text;

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      int? userId = prefs.getInt('userId');

                      if (userId != null) {
                        try {
                          final response = await http.put(
                            Uri.parse(
                                'http://stajyerapp.runasp.net/api/User/ChangePassword'),
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode({
                              'userId': userId,
                              'oldPassword': oldPassword,
                              'newPassword': newPassword,
                            }),
                          );

                          if (response.statusCode == 204) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Şifreniz başarıyla güncellendi.'),
                              ),
                            );
                            Navigator.of(context).pop();
                          } else if (response.statusCode == 409) {
                            setState(() {
                              newPasswordError = "Yeni şifreler eşleşmiyor";
                            });
                          } else {
                            setState(() {
                              oldPasswordError = "${response.body}";
                            });
                          }
                        } catch (e) {
                          setState(() {
                            oldPasswordError = "$e";
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Kullanıcı ID bulunamadı')),
                        );
                      }
                    }
                  },
                  child: Text(
                    "Değiştir",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("İptal", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password); // Şifreyi byte dizisine çevirin
    final digest = sha256.convert(bytes); // SHA-256 hash'ini hesaplayın
    return digest.toString(); // Hash'lenmiş şifreyi döndürün
  }

  void selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0:
        // Çıkış yapma işlemleri
        print("Çıkış Yap");
        break;
      case 1:
        // Şifre değiştirme işlemleri
        print("Şifre Değiştir");
        break;
    }
  }

  void _showAddProjectDialog() async {
    bool? result = await showAddProjectDialog(context);
    if (result ?? false) {
      _getUserInfo();
    }
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    final RegExp phoneRegex =
        RegExp(r'^\d{11}$'); // Tam olarak 11 haneli telefon numarası
    return phoneRegex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final List<ProfileItem> profileItems = [
      ProfileItem(
        icon: Icon(Icons.person),
        title: "Hakkımda: ",
        value: user?.udesc ?? 'Belirtilmemiş',
        onEdit: () {
          _editInfo(context, "", user?.udesc ?? '', "udesc");
        },
      ),
      ProfileItem(
        icon: Icon(Icons.email),
        title: "Email: ",
        value: user?.uemail ?? 'Belirtilmemiş',
        onEdit: () {
          _editInfo(context, "Email", user?.uemail ?? '', "uemail");
        },
      ),
      ProfileItem(
        icon: Icon(Icons.cake),
        title: "Doğum Tarihi: ",
        value: user?.ubirthdate ?? 'Belirtilmemiş',
        onEdit: () {
          _editInfo(
              context, "Doğum Tarihi", user?.ubirthdate ?? '', "ubirthdate");
        },
      ),
      ProfileItem(
        icon: Icon(Icons.phone),
        title: "Telefon Numarası: ",
        value: user?.uphone ?? 'Belirtilmemiş',
        onEdit: () {
          _editInfo(context, "Telefon Numarası", user?.uphone ?? '', "uphone");
        },
      ),
      ProfileItem(
        icon: Icon(Icons.account_circle),
        title: "Github Adresi: ",
        value: user?.ugithub ?? 'Belirtilmemiş',
        onEdit: () {
          _editInfo(context, "Github Adresi", user?.ugithub ?? '', "ugithub");
        },
      ),
      ProfileItem(
        icon: Icon(Icons.link),
        title: "Linkedin Adresi: ",
        value: user?.ulinkedin ?? 'Belirtilmemiş',
        onEdit: () {
          _editInfo(
              context, "Linkedin Adresi", user?.ulinkedin ?? '', "ulinkedin");
        },
      ),
      ProfileItem(
        icon: Icon(Icons.book),
        title: "Cv: ",
        value: user?.ucv ?? 'Belirtilmemiş',
        onEdit: () {
          _editInfo(context, "Cv", user?.ucv ?? '', "ucv");
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // Geri butonunu kaldır

        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Profil",
                style: TextStyle(
                    color: button, fontSize: 25, fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),

        actions: [
          PopupMenuButton<int>(
            offset: Offset(0.0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            color: Colors.white,
            icon: Icon(Icons.settings),
            onSelected: (item) => selectedItem(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: SizedBox(
                  width: 200, // Butonun genişliğini belirli bir değere sabitle
                  child: Column(children: [
                    GestureDetector(
                      onTap: () {
                        // Menüden çık
                        _logoOut(); // Çıkış yapma fonksiyonunu çalıştır
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Çıkış Yap"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(height: 20, color: Colors.grey), // Çizgi ekleme
                  ]),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: SizedBox(
                  width: 200, // Butonun genişliğini belirli bir değere sabitle
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _changePassword(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Şifre Değiştir"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : user != null
                ? SingleChildScrollView(
                    child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ilanCard,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _updateProfilePhoto,
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: ClipOval(
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Image.network(
                                          (user?.uprofilephoto ==
                                                  'http://stajyerapp.runasp.net/Photos/UserProfilePhotos/blank_profile_photo.png')
                                              ? 'https://via.placeholder.com/150'
                                              : user?.uprofilephoto ??
                                                  'https://via.placeholder.com/150',
                                          width: 90,
                                          height: 90,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "${user!.uname} ${user!.usurname}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Divider(
                                  color: Colors.white, // Çizginin rengi
                                  thickness: 1, // Çizginin kalınlığı
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...profileItems.map((item) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5.0),
                                                      child: Icon(
                                                        size:
                                                            screenHeight * 0.03,
                                                        item.icon.icon,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.title,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.value,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            onPressed: item.onEdit,
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                    Divider(
                                      color: Colors.white, // Çizginin rengi
                                      thickness: 1, // Çizginin kalınlığı
                                    ),
                                    ExpansionTile(
                                      title: Text(
                                        "Projeler",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      children: [
                                        UserProjectsWidget(
                                          userId: user?.userId ?? 0,
                                        ),
                                      ],
                                      trailing: Icon(
                                        Icons.expand_more,
                                        color: Colors
                                            .white, // İstediğiniz rengi buraya koyabilirsiniz
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white, // Çizginin rengi
                                      thickness: 1, // Çizginin kalınlığı
                                    ),
                                    SizedBox(height: 10),
                                    ExpansionTile(
                                      title: Text(
                                        "Sertifikalar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      children: [
                                        UserCertificateWidget(
                                          userId: user?.userId ?? 0,
                                        ),
                                      ],
                                      trailing: Icon(
                                        Icons.expand_more,
                                        color: Colors
                                            .white, // İstediğiniz rengi buraya koyabilirsiniz
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white, // Çizginin rengi
                                      thickness: 1, // Çizginin kalınlığı
                                    ),
                                    SizedBox(height: 10),
                                    ExpansionTile(
                                      title: Text(
                                        "Eğitim",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      children: [
                                        UserEducationWidget(
                                          userId: user?.userId ?? 0,
                                        ),
                                      ],
                                      trailing: Icon(
                                        Icons.expand_more,
                                        color: Colors
                                            .white, // İstediğiniz rengi buraya koyabilirsiniz
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white, // Çizginin rengi
                                      thickness: 1, // Çizginin kalınlığı
                                    ),
                                    SizedBox(height: 10),
                                    ExpansionTile(
                                      title: Text(
                                        "Deneyim",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      children: [
                                        UserExperienceWidget(
                                          userId: user?.userId ?? 0,
                                        ),
                                      ],
                                      trailing: Icon(
                                        Icons.expand_more,
                                        color: Colors
                                            .white, // İstediğiniz rengi buraya koyabilirsiniz
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: ilanCard,
                      //       foregroundColor: Colors.white,
                      //     ),
                      //     onPressed: () {
                      //       _changePassword(context);
                      //     },
                      //     child: const Text("Şifre Değiştir"),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: double
                      //       .infinity, // Ensures the width takes up the full available space
                      //   child: Center(
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         minimumSize: Size(double.infinity,
                      //             40), // Make the button's width match its parent
                      //         backgroundColor: Colors.red,
                      //         foregroundColor: Colors.white,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(30.0),
                      //         ),
                      //       ),
                      //       onPressed: _logoOut,
                      //       child: Text("Çıkış Yap"),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ))
                : Text('Kullanıcı bulunamadı'),
      ),
    );
  }
}

class ProfileItem {
  final String title;
  final String value;
  final void Function() onEdit;
  final Icon icon;

  ProfileItem({
    required this.title,
    required this.value,
    required this.onEdit,
    required this.icon,
  });
}
