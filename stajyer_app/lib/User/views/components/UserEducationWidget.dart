import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stajyer_app/User/models/EducationModel.dart';
import 'package:stajyer_app/User/services/api/EducationService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/AddEducation.dart';

class UserEducationWidget extends StatefulWidget {
  final int userId;

  const UserEducationWidget({Key? key, required this.userId}) : super(key: key);

  @override
  _UserEducationWidgetState createState() => _UserEducationWidgetState();
}

class _UserEducationWidgetState extends State<UserEducationWidget> {
  List<EducationModel> educations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEducations();
  }

  Future<void> _fetchEducations() async {
    try {
      final educations =
          await EducationService().GetUserEducations(widget.userId);
      print(
          'API Yanıtı: $educations'); // educations burada List<EducationModel>

      setState(() {
        this.educations = educations;
        isLoading = false;
      });
    } catch (error) {
      print("Eğitim bilgileri alınırken hata oluştu: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showAddEducationDialog() async {
    bool? result = await showAddEducationDialog(context);
    if (result ?? false) {
      _fetchEducations(); // Eğitimler eklendikten sonra yeniden yükle
    }
  }

  Future<void> _deleteEducation(int? educationId) async {
    if (educationId != null) {
      try {
        await EducationService().deleteEducation(educationId);
        setState(() {
          educations.removeWhere((education) => education.eduId == educationId);
        });
      } catch (error) {
        print("Eğitim silinirken hata oluştu: $error");
      }
    } else {
      print('Eğitim ID null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = background;
    final buttonColor = ilanCard; // Kullanıcı tanımlı renk

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (educations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Eğitimleriniz bulunmamaktadır.",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 40),
                backgroundColor: Colors.white,
                foregroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: _showAddEducationDialog,
              child: Text('Yeni Eğitim Ekle'),
            ),
          ],
        ),
      );
    } else {
      return Container(
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 40),
                      backgroundColor: ilanCard,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: _showAddEducationDialog,
                    child: Text('Yeni Eğitim'),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: educations.length,
                  itemBuilder: (context, index) {
                    final education = educations[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 4.0), // Space between items
                      padding: EdgeInsets.all(12.0), // Padding inside item
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  education.uniName ?? "Üniversite Adı",
                                  style: TextStyle(
                                      color: buttonColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  '${education.eduStartDate ?? "Başlangıç Tarihi"} - ${education.eduFinishDate ?? "Bitiş Tarihi"}',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: buttonColor),
                            onPressed: () {
                              _deleteEducation(education.eduId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
