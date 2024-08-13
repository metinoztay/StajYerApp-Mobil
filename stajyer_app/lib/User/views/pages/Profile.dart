import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    TextEditingController controller = TextEditingController(text: "");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Güncelle", style: TextStyle(color: ilanCard)),
          content: fieldName == "udesc"
              ? Container(
                  width: double.maxFinite,
                  child: TextField(
                    controller: controller,
                    maxLines:
                        8, // Daha büyük bir text alanı için satır sayısını artırdık
                    decoration: InputDecoration(
                      labelText: title,
                      border: OutlineInputBorder(),
                    ),
                  ),
                )
              : TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: title),
                ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ilanCard,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final newValue = controller.text;

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
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Şifre Değiştir", style: TextStyle(color: ilanCard)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Eski Şifre"),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Yeni Şifre"),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Yeni Şifre Tekrar"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ilanCard,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final oldPassword = oldPasswordController.text;
                final newPassword = newPasswordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Yeni şifreler eşleşmiyor.'),
                    ),
                  );
                  return;
                }

                SharedPreferences prefs = await SharedPreferences.getInstance();
                int? userId = prefs.getInt('userId');

                if (userId != null) {
                  UserService userService = UserService();

                  try {
                    UserModel currentUser =
                        await userService.getUserById(userId);

                    if (currentUser.upassword != oldPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Eski şifre yanlış.'),
                        ),
                      );
                      return;
                    }

                    Map<String, dynamic> updatedData = {
                      'userId': userId,
                      'uname': currentUser.uname,
                      'usurname': currentUser.usurname,
                      'uemail': currentUser.uemail,
                      'upassword': newPassword,
                      'uphone': currentUser.uphone,
                      'ubirthdate': currentUser.ubirthdate,
                      'ugender': currentUser.ugender,
                      'ulinkedin': currentUser.ulinkedin,
                      'ucv': currentUser.ucv,
                      'ugithub': currentUser.ugithub,
                      'udesc': currentUser.udesc,
                      'uprofilephoto': currentUser.uprofilephoto,
                      'uisactive': currentUser.uisactive,
                      'uisEmailVerified': currentUser.uisEmailVerified,
                      'uisPhoneVerified': currentUser.uisPhoneVerified,
                    };

                    await userService.updateUser(userId, updatedData);

                    _getUserInfo();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Şifreniz başarıyla güncellendi.'),
                      ),
                    );

                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Şifre değiştirme sırasında bir hata oluştu: $e'),
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
  }

  void _showAddProjectDialog() async {
    bool? result = await showAddProjectDialog(context);
    if (result ?? false) {
      _getUserInfo();
    }
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
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : user != null
                ? SingleChildScrollView(
                    child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ilanCard,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
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
                                          user?.uprofilephoto ??
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
                                            icon: Icon(Icons.edit,
                                                color: Colors.white),
                                            onPressed: item.onEdit,
                                          ),
                                        ],
                                      );
                                    }).toList(),
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
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _changePassword(context);
                        },
                        child: const Text("Şifre Değiştir"),
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 40),
                            backgroundColor: Colors.white,
                            foregroundColor: ilanCard,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: _logoOut,
                          child: Text("Çıkış Yap"),
                        ),
                      ),
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
