import 'package:flutter/material.dart';
import 'package:stajyer_app/User/models/ExperienceModel.dart';
import 'package:stajyer_app/User/services/api/ExperienceService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/AddExperience.dart';

class UserExperienceWidget extends StatefulWidget {
  final int userId;

  const UserExperienceWidget({Key? key, required this.userId})
      : super(key: key);

  @override
  State<UserExperienceWidget> createState() => _UserExperienceWidgetState();
}

class _UserExperienceWidgetState extends State<UserExperienceWidget> {
  List<ExperienceModel> experiences = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExperiences();
  }

  Future<void> _fetchExperiences() async {
    try {
      List<ExperienceModel> fetchedExperiences =
          await ExperienceService().GetUserExperiences(widget.userId);
      setState(() {
        experiences = fetchedExperiences;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching experiences: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showAddExperienceDialog() async {
    bool? result = await showAddExperienceDialog(context);
    if (result ?? false) {
      _fetchExperiences();
    }
  }

  Future<void> _deleteExperience(int? experienceId) async {
    if (experienceId != null) {
      try {
        await ExperienceService().deleteExperience(experienceId);
        setState(() {
          experiences
              .removeWhere((experience) => experience.expId == experienceId);
        });
      } catch (error) {
        print("Error deleting experience: $error");
      }
    } else {
      print('Experience ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = background;
    final buttonColor = Colors.blueAccent; // Custom color

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (experiences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Deneyimleriniz bulunmamaktadır.",
              style: TextStyle(color: backgroundColor),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 40),
                backgroundColor: Colors.white,
                foregroundColor: ilanCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: _showAddExperienceDialog,
              child: Text('Yeni Deneyim Ekle'),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deneyimlerim',
                    style: TextStyle(
                      color: ilanCard,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                      backgroundColor: ilanCard,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: _showAddExperienceDialog,
                    child: Text('Yeni Deneyim'),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: experiences.length,
                  itemBuilder: (context, index) {
                    final experience = experiences[index];
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
                                  experience.expPosition ?? "Pozisyon",
                                  style: TextStyle(
                                      color: ilanCard,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  experience.expDesc ?? "Açıklama",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: ilanCard),
                            onPressed: () {
                              _deleteExperience(experience.expId);
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
