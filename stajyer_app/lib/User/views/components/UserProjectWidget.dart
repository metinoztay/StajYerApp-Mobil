import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stajyer_app/User/models/ProjectModel.dart';
import 'package:stajyer_app/User/services/api/ProjectService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/AddProje.dart';

class UserProfilePage extends StatelessWidget {
  final int userId;

  UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profilim')),
      body: ListView(
        children: [
          // Diğer profil bilgileri burada
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ExpansionTile(
              title: Text(
                "Projelerim",
                style: TextStyle(color: Colors.white),
              ),
              children: [
                UserProjectsWidget(userId: userId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserProjectsWidget extends StatefulWidget {
  final int userId;

  UserProjectsWidget({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _UserProjectsWidgetState createState() => _UserProjectsWidgetState();
}

class _UserProjectsWidgetState extends State<UserProjectsWidget> {
  List<ProjectModel> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    try {
      List<ProjectModel> fetchedProjects =
          await ProjectService().getUserProjects(widget.userId);
      setState(() {
        projects = fetchedProjects;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showAddProjectDialog() async {
    bool? result = await showAddProjectDialog(context);
    if (result ?? false) {
      _fetchProjects();
    }
  }

  Future<void> _deleteProject(int? projectId) async {
    if (projectId != null) {
      try {
        await ProjectService().deleteProject(projectId);
        setState(() {
          projects.removeWhere((project) => project.proId == projectId);
        });
      } catch (error) {
        print('Proje silinirken hata oluştu: $error');
      }
    } else {
      print('Project ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = background;
    final buttonColor = ilanCard; // Kullanıcı tanımlı renk

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Projeniz bulunmamaktadır",
              style: TextStyle(color: buttonColor),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 40),
                backgroundColor: Colors.white,
                foregroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: _showAddProjectDialog,
              child: Text('Yeni Proje Ekle'),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                      backgroundColor: ilanCard,
                      foregroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: _showAddProjectDialog,
                    child: Text(
                      'Yeni Proje Ekle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300), // Height constraint
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 8.0), // Space between items
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
                                  project.proName ?? "Proje Adı",
                                  style: TextStyle(
                                      color: buttonColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  project.proDesc ?? "Proje Açıklaması",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_sharp, color: buttonColor),
                            onPressed: () {
                              _deleteProject(project.proId);
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
