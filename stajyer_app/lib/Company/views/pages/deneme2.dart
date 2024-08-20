import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/models/AppUserModel.dart';
import 'package:stajyer_app/Company/services/api/ApplicationService.dart';

class ApplicantsPage extends StatelessWidget {
  final int advertId;

  ApplicantsPage({required this.advertId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Başvuranlar')),
      body: FutureBuilder<List<AppUserModel>>(
        future: ApplicationService().fetchApplicants(advertId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Başvuran bulunamadı'));
          } else {
            final applicants = snapshot.data!;
            return ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final user = applicants[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ExpansionTile(
                    leading: user.uprofilephoto != null
                        ? Image.network(user.uprofilephoto!,
                            width: 50, height: 50, fit: BoxFit.cover)
                        : null,
                    title: Text('${user.uname} ${user.usurname}'),
                    subtitle: Text(user.uemail ?? ""),
                    children: <Widget>[
                      ListTile(
                        title: Text('Email: ${user.uemail ?? "N/A"}'),
                      ),
                      ListTile(
                        title: Text('Phone: ${user.uphone ?? "N/A"}'),
                      ),
                      ListTile(
                        title: Text('Birthdate: ${user.ubirthdate ?? "N/A"}'),
                      ),
                      // Add more details if needed
                    ],
                    onExpansionChanged: (bool expanded) {
                      if (expanded) {
                        // Optional: Perform actions when expanded
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
