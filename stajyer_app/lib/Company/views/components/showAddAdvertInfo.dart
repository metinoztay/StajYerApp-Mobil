import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/views/pages/CompanyProfile.dart';

Future<void> showAddAdvertInfo(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible:
        false, // Dialog dışında tıklama ile kapanmasını engeller
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Şirket Bilgisi Gerekiyor'),
        content: Text(
            'İlan ekleyebilmek için önce profil kısmından şirket eklemeniz gerekmektedir.'),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => CompanyProfile()),
          //     );
          //   },
          //   child: Text('Şirket Ekle'),
          // ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dialogu kapatır
            },
            child: Text('Kapat'),
          ),
        ],
      );
    },
  );
}
