import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/compuserNewPasswordModel.dart';
import 'package:stajyer_app/Company/services/api/compuserNewPasswordService.dart';

class CreatePasswordPopup extends StatelessWidget {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Şifreyi Değiştir"),
      content: SizedBox(
        width: 300,
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(hintText: "Eski Şifre"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(hintText: "Yeni Şifreyi Onaylayın"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _changePassword(context),
              child: Text("Şifreyi Değiştir"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    // Retrieve the compUserId from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? compUserId = prefs.getInt('compUserId');

    if (compUserId == null) {
      // Handle missing compUserId
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı kimliği bulunamadı.")),
      );
      return;
    }

    // Create the model
    CompUserNewPasswordModel model = CompUserNewPasswordModel(
      compUserId: compUserId,
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    // Call the service to change the password
    try {
      await CompUserNewPasswordService().changePassword(model);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Şifre başarıyla değiştirildi.")),
      );
      Navigator.of(context).pop(); // Close the popup
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Şifre değiştirme başarısız. Lütfen tekrar deneyin.")),
      );
    }
  }
}
