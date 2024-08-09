import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/models/savingAddDeleteModel.dart';
import 'package:stajyer_app/User/services/api/savingAddDeleteService.dart';

class SaveButton extends StatefulWidget {
  final int advertId;
  final Color ColorSave;

  const SaveButton({super.key, required this.advertId, required this.ColorSave});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _isSaved = false; // Track if advert is saved
  late SavingService _savingService;
  int? _userId; // User ID from device memory

  @override
  void initState() {
    super.initState();
    _savingService = SavingService();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId'); // Load user ID from device memory
      _checkIfAdvertIsSaved(); // Check if the advert is saved
    });
  }

  Future<void> _checkIfAdvertIsSaved() async {
    if (_userId == null) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedAdverts = prefs.getStringList('savedAdverts_$_userId') ?? [];
    setState(() {
      _isSaved = savedAdverts.contains(widget.advertId.toString());
    });
  }

  Future<void> _toggleSave() async {
    if (_userId == null) {
      print('User ID could not be loaded');
      return;
    }

    final model = SavingAddDeleteModel(userId: _userId, advertId: widget.advertId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedAdverts = prefs.getStringList('savedAdverts_$_userId') ?? [];

    if (_isSaved) {
      final response = await _savingService.deleteSaving(model);
      if (response.statusCode == 200) {
        setState(() {
          _isSaved = false;
          savedAdverts.remove(widget.advertId.toString());
        });
        await prefs.setStringList('savedAdverts_$_userId', savedAdverts);
      } else {
        // Error handling
        print('Delete operation failed: ${response.statusCode}');
      }
    } else {
      final response = await _savingService.addSaving(model);
      if (response.statusCode == 200) {
        setState(() {
          _isSaved = true;
          savedAdverts.add(widget.advertId.toString());
        });
        await prefs.setStringList('savedAdverts_$_userId', savedAdverts);
      } else {
        // Error handling
        print('Add operation failed: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleSave,
      icon: Icon(
        _isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
        color: widget.ColorSave,
        size: 25,
      ),
    );
  }
}
