import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/models/compuserNewPasswordModel.dart';
import 'package:stajyer_app/Company/services/api/compuserNewPasswordService.dart';

class CreatePasswordPopup extends StatefulWidget {
  final int compUserId;

  CreatePasswordPopup({required this.compUserId});

  @override
  _CreatePasswordPopupState createState() => _CreatePasswordPopupState();
}

class _CreatePasswordPopupState extends State<CreatePasswordPopup> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final CompUserNewPasswordService _service = CompUserNewPasswordService();

  void _changePassword() async {
    if (_oldPasswordController.text.isEmpty || _newPasswordController.text.isEmpty) {
      // Show an error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }

    final model = CompUserNewPasswordModel(
      compUserId: widget.compUserId,
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    try {
      await _service.changePassword(model);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre başarıyla değiştirildi.')),
      );
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      print("widget.");
      print(widget.compUserId);
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre değiştirilemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: AlertDialog(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _changePassword,
                  child: Text('Şifreyi Değiştir'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
