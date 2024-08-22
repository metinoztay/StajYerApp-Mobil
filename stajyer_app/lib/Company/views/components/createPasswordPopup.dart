import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/models/compuserNewPasswordModel.dart';
import 'package:stajyer_app/Company/services/api/compuserNewPasswordService.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class CreatePasswordPopup extends StatefulWidget {
  final int compUserId;

  CreatePasswordPopup({required this.compUserId});

  @override
  _CreatePasswordPopupState createState() => _CreatePasswordPopupState();
}

class _CreatePasswordPopupState extends State<CreatePasswordPopup> {
  final _formKey = GlobalKey<FormState>();

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
    if (_formKey.currentState?.validate() ?? false) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Yeni Şifre Oluştur',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Eski şifreyi giriniz.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Yeni şifreyi giriniz.';
                    } else if (value == _oldPasswordController.text) {
                      return 'Yeni şifre eski şifre ile aynı olamaz.';
                    } else if (value.length < 5) {
                      return 'Şifre en az 8 karakter uzunluğunda olmalıdır.';
                    }

                    return null;
                  }),
              SizedBox(height: 10),
              TextFormField(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Şifreyi onaylayın.';
                  } else if (value != _newPasswordController.text) {
                    return 'Yeni şifreler eşleşmiyor.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text(
                  'Şifreyi Değiştir',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 24, 58),
                  minimumSize: Size(double.infinity, 36), // Full width button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
