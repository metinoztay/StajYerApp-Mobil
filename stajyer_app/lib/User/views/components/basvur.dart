// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stajyer_app/models/UserModel.dart';
// import 'package:stajyer_app/models/applyModel.dart';
// import 'package:stajyer_app/models/applybuttonmodel.dart';
// import 'package:stajyer_app/models/verificationEmailModel.dart';
// import 'package:stajyer_app/services/api/UserService.dart';
// import 'package:stajyer_app/services/api/applyService.dart';
// import 'package:stajyer_app/services/api/applybuttonservice.dart';
// import 'package:stajyer_app/services/api/verificationEmailService.dart';
// import 'package:stajyer_app/utils/colors.dart';

// class ApplicationButton extends StatefulWidget {
//   final int advertId;

//   ApplicationButton({required this.advertId});

//   @override
//   State<ApplicationButton> createState() => _ApplicationButtonState();
// }

// class _ApplicationButtonState extends State<ApplicationButton> {
//   final ApplyButtonService _applyButtonService = ApplyButtonService();
//   final UserService _userService = UserService();
//   final VerificationService _verificationService = VerificationService();
//   bool _isButtonDisabled = false;
//   bool _isEmailVerified = true;

//   @override
//   void initState() {
//     super.initState();
//     _checkApplicationStatus();
//   }

//   Future<void> _checkApplicationStatus() async {
//     int? userId = await _getUserId();
//     if (userId != null) {
//       ApplyButtonModel model = ApplyButtonModel(userId: userId, advertId: widget.advertId);
//       bool result = await _applyButtonService.sendApplyButtonRequest(model);
//       setState(() {
//         _isButtonDisabled = result;
//       });

//       // Email doğrulama durumunu kontrol et
//       await _checkEmailVerification(userId);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Kullanıcı ID alınamadı.')),
//       );
//     }
//   }

//   Future<void> _checkEmailVerification(int userId) async {
//     try {
//       UserModel user = await _userService.getUserById(userId);
//       setState(() {
//         _isEmailVerified = user.uisEmailVerified ?? false;
//       });
//     } catch (e) {
//       print('Email doğrulama kontrolü sırasında hata oluştu: $e');
//       setState(() {
//         _isEmailVerified = false;
//       });
//     }
//   }

//   Future<int?> _getUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('userId');
//   }

//   Future<void> _sendVerificationCode(int userId) async {
//     try {
//       await _verificationService.sendVerificationCode(userId.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Doğrulama kodu e-posta adresinize gönderildi.')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Doğrulama kodu gönderilemedi. Lütfen tekrar deneyin.')),
//       );
//     }
//   }

//   void _showApplicationDialog(BuildContext context) {
//     if (_isEmailVerified) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               width: 600,
//               height: 500,
//               padding: EdgeInsets.all(16),
//               child: ApplicationForm(
//                 advertId: widget.advertId,
//                 onApplicationSubmitted: () {
//                   setState(() {
//                     _isButtonDisabled = true;
//                   });
//                 },
//               ),
//             ),
//           );
//         },
//       );
//     } else {
//       _showEmailVerificationDialog(context);
//     }
//   }

//   void _showEmailVerificationDialog(BuildContext context) {
//     final _codeController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Container(
//             width: 400,
//             height: 300,
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Maili Onayla',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Mailinize gönderilen kodu giriniz.'),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: _codeController,
//                   decoration: InputDecoration(
//                     hintText: 'Doğrulama kodunu buraya girin',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () async {
//                     int? userId = await _getUserId();
//                     if (userId != null) {
//                       try {
//                         await _verificationService.verifyEmail(userId.toString(), _codeController.text);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('E-posta adresiniz başarıyla doğrulandı.')),
//                         );
//                         Navigator.of(context).pop(); // Popup'ı kapat
//                         _checkApplicationStatus(); // Başvuru butonunu güncelle
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Doğrulama kodu geçersiz veya bir hata oluştu.')),
//                         );
//                       }
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Kullanıcı ID alınamadı.')),
//                       );
//                     }
//                   },
//                   child: Text('Doğrula'),
//                 ),
//                 SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Popup'ı kapat
//                   },
//                   child: Text('İptal'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );

//     // Send verification code when dialog is shown
//     _getUserId().then((userId) {
//       if (userId != null) {
//         _sendVerificationCode(userId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: _isButtonDisabled ? null : () => _showApplicationDialog(context),
//       child: Text(
//         _isButtonDisabled ? 'Başvuru Yapıldı' : 'Başvuru Yap',
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: button,
//         ),
//       ),
//     );
//   }
// }

// class ApplicationForm extends StatefulWidget {
//   final int advertId;
//   final VoidCallback onApplicationSubmitted;

//   ApplicationForm({required this.advertId, required this.onApplicationSubmitted});

//   @override
//   _ApplicationFormState createState() => _ApplicationFormState();
// }

// class _ApplicationFormState extends State<ApplicationForm> {
//   final TextEditingController _controller = TextEditingController();
//   final ApplyService _applyService = ApplyService();
//   int? _userId;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserId();
//   }

//   Future<void> _fetchUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _userId = prefs.getInt('userId');
//     });
//   }

//   void _submitApplication() async {
//     if (_userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Kullanıcı ID alınamadı.')),
//       );
//       return;
//     }

//     String appLetter = _controller.text;
//     String appDate = DateTime.now().toIso8601String();
//     ApplyModel applyModel = ApplyModel(
//       userId: _userId!,
//       advertId: widget.advertId,
//       appDate: appDate,
//       appLetter: appLetter,
//     );

//     bool success = await _applyService.sendApplication(applyModel);

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Başvuru başarılı bir şekilde gönderildi.')),
//       );
//       widget.onApplicationSubmitted();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Başvuru gönderilemedi. Lütfen tekrar deneyin.')),
//       );
//     }

//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             'Başvuru Metni',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 16),
//           TextField(
//             controller: _controller,
//             maxLength: 700,
//             maxLines: 10,
//             decoration: InputDecoration(
//               hintText: 'Başvuru metninizi buraya yazın',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           SizedBox(height: 16),
//           Text("Başvuruda kullanılacak bilgileri profilden düzenleyebilirsiniz"),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               TextButton(
//                 child: Text('İptal'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text('Gönder'),
//                 onPressed: _submitApplication,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/models/UserModel.dart';
import 'package:stajyer_app/User/models/applyModel.dart';
import 'package:stajyer_app/User/models/applybuttonmodel.dart';
import 'package:stajyer_app/User/services/api/UserService.dart';
import 'package:stajyer_app/User/services/api/applyService.dart';
import 'package:stajyer_app/User/services/api/applybuttonservice.dart';
import 'package:stajyer_app/User/services/api/verificationEmailService.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class ApplicationButton extends StatefulWidget {
  final int advertId;

  ApplicationButton({required this.advertId});

  @override
  State<ApplicationButton> createState() => _ApplicationButtonState();
}

class _ApplicationButtonState extends State<ApplicationButton> {
  final ApplyButtonService _applyButtonService = ApplyButtonService();
  final UserService _userService = UserService();
  final VerificationService _verificationService = VerificationService();
  bool _isButtonDisabled = false;
  bool _isEmailVerified = true;

  @override
  void initState() {
    super.initState();
    _checkApplicationStatus();
  }

  Future<void> _checkApplicationStatus() async {
    int? userId = await _getUserId();
    if (userId != null) {
      ApplyButtonModel model =
          ApplyButtonModel(userId: userId, advertId: widget.advertId);
      bool result = await _applyButtonService.sendApplyButtonRequest(model);
      setState(() {
        _isButtonDisabled = result;
      });

      // Email doğrulama durumunu kontrol et
      await _checkEmailVerification(userId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı ID alınamadı.')),
      );
    }
  }

  Future<void> _checkEmailVerification(int userId) async {
    try {
      UserModel user = await _userService.getUserById(userId);
      setState(() {
        _isEmailVerified = user.uisEmailVerified ?? false;
      });
    } catch (e) {
      print('Email doğrulama kontrolü sırasında hata oluştu: $e');
      setState(() {
        _isEmailVerified = false;
      });
    }
  }

  Future<int?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> _sendVerificationCode(int userId) async {
    try {
      await _verificationService.sendVerificationCode(userId.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Doğrulama kodu e-posta adresinize gönderildi.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Doğrulama kodu gönderilemedi. Lütfen tekrar deneyin.')),
      );
    }
  }

  void _showApplicationDialog(BuildContext context) {
    if (_isEmailVerified) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 600,
              height: 500,
              padding: EdgeInsets.all(16),
              child: ApplicationForm(
                advertId: widget.advertId,
                onApplicationSubmitted: () {
                  setState(() {
                    _isButtonDisabled = true;
                  });
                },
              ),
            ),
          );
        },
      );
    } else {
      _showInitialVerificationDialog(context);
    }
  }
void _showInitialVerificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: GirisCard,
              ),
              width: 500,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'E-mailini Doğrulaman Lazım',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // İlk popup'ı kapat
                      _showEmailVerificationDialog(context); // İkinci popup'u aç
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ilanCard,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text('E-maile Kod Gönder'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // İlk popup'ı kapat
                    },
                    child: Text(
                      'İptal',
                      style: TextStyle(color: ilanCard),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}



void _showEmailVerificationDialog(BuildContext context) {
  final TextEditingController _codeController = TextEditingController();
  int _remainingSeconds = 5;
  bool _isButtonDisabled = true;
  Timer? _timer;

  void _startCountdown(StateSetter setState) {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 5;
      _isButtonDisabled = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _isButtonDisabled = false;
          timer.cancel();
        }
      });
    });
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // İlk başta geri sayımı başlat
          if (_timer == null) {
            _startCountdown(setState);
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: GirisCard,
                  ),
                  width: 500,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Maili Onayla',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mailinize gönderilen kodu giriniz',
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      PinCodeTextField(
                        controller: _codeController,
                        appContext: context,
                        length: 6,
                        onChanged: (value) {},
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          activeColor: Colors.black,
                          inactiveColor: Colors.black,
                          selectedColor: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ilanCard,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          int? userId = await _getUserId();
                          if (userId != null) {
                            try {
                              await _verificationService.verifyEmail(userId.toString(), _codeController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('E-posta adresiniz başarıyla doğrulandı.')),
                              );
                              Navigator.of(context).pop(); // Popup'ı kapat
                              _checkApplicationStatus(); // Başvuru butonunu güncelle
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Doğrulama kodu geçersiz veya bir hata oluştu.')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Kullanıcı ID alınamadı.')),
                            );
                          }
                        },
                        child: Text(
                          'Doğrula',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _isButtonDisabled
                            ? null
                            : () async {
                                int? userId = await _getUserId();
                                if (userId != null) {
                                  await _sendVerificationCode(userId);
                                  _startCountdown(setState);
                                }
                              },
                       
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _isButtonDisabled
                                ? 'Yeniden Gönder (${_remainingSeconds}s)'
                                : 'Yeniden Gönder',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Popup'ı kapat
                          _timer?.cancel();
                        },
                        child: Text(
                          'İptal',
                          style: TextStyle(color: ilanCard),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );

  // Diyalog gösterildiğinde doğrulama kodunu gönder
  _getUserId().then((userId) {
    if (userId != null) {
      _sendVerificationCode(userId);
    }
  });
}



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          _isButtonDisabled ? null : () => _showApplicationDialog(context),
      child: Text(
        _isButtonDisabled ? 'Başvuru Yapıldı' : 'Başvuru Yap',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: button,
        ),
      ),
    );
  }
}

class ApplicationForm extends StatefulWidget {
  final int advertId;
  final VoidCallback onApplicationSubmitted;

  ApplicationForm(
      {required this.advertId, required this.onApplicationSubmitted});

  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final TextEditingController _controller = TextEditingController();
  final ApplyService _applyService = ApplyService();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
    });
  }

  void _submitApplication() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı ID alınamadı.')),
      );
      return;
    }

    String appLetter = _controller.text;
    String appDate = DateTime.now().toIso8601String();
    ApplyModel applyModel = ApplyModel(
      userId: _userId!,
      advertId: widget.advertId,
      appLetter: appLetter,
      appDate: appDate,
    );

    bool result = await _applyService.sendApplication(applyModel);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Başvuru başarıyla gönderildi.')),
      );
      widget.onApplicationSubmitted();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Başvuru gönderilemedi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Başvuru Metni',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLength: 700,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Başvuru metninizi buraya yazın',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Text("Başvuruda kullanılacak bilgileri profilden düzenleyebilirsiniz"),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: Text('İptal'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Gönder'),
                onPressed: _submitApplication,
              ),
            ],
          ),
        ],
      ),
    );
  }
}