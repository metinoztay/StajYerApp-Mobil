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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final CompUserNewPasswordService _service = CompUserNewPasswordService();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _changePassword() async {
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yeni şifreler eşleşmiyor.')),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre başarıyla değiştirildi.')),
      );
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre değiştirilemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text('Şifre Değiştir', style: TextStyle(fontWeight: FontWeight.bold)),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      content: SizedBox(
        width: 280, // Smaller width
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  labelText: 'Eski Şifre',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureOldPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _toggleOldPasswordVisibility,
                  ),
                ),
                obscureText: _obscureOldPassword,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _toggleNewPasswordVisibility,
                  ),
                ),
                obscureText: _obscureNewPassword,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifreyi Onaylayın',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
                obscureText: _obscureConfirmPassword,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Şifreyi Değiştir'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity,
                      36), // Full width button with smaller height
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
