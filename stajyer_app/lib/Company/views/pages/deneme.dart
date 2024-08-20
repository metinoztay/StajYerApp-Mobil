import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/models/AppUserModel.dart';
import 'package:stajyer_app/Company/services/api/ApplicationService.dart';
import 'package:stajyer_app/User/models/UserModel.dart';

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
                // Başvuru mektubu ve tarihlerini göstermek için
                final applicationDetails = user.applications
                    .map((app) => '${app.appDate}: ${app.appLetter}')
                    .join('\n\n');

                return ListTile(
                  leading: user.uprofilephoto != null
                      ? Image.network(user.uprofilephoto!)
                      : null,
                  title: Text('${user.uname} ${user.usurname}'),
                  subtitle: Text(
                    'Email: ${user.uemail ?? ""}\n'
                    'Başvurular:\n$applicationDetails',
                  ),
                  onTap: () {
                    // Detay sayfasına yönlendirilebilir
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
