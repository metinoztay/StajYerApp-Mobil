import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/models/AppUserModel.dart';
import 'package:stajyer_app/Company/services/api/ApplicationService.dart';

class AdvertApplications extends StatefulWidget {
  final int advertId; //zorunlu bir advert id
  AdvertApplications({required this.advertId});

  @override
  _AdvertApplicationsState createState() => _AdvertApplicationsState();
}

class _AdvertApplicationsState extends State<AdvertApplications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Başvuranlar')),
      body: FutureBuilder<List<AppUserModel>>(
        future: ApplicationService().fetchApplicants(widget.advertId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Başvuran bulunamadı'),
            );
          } else {
            final applicants = snapshot.data!;
            return ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final user = applicants[index];
                return _ApplicantCard(user: user);
              },
            );
          }
        },
      ),
    );
  }
}

class _ApplicantCard extends StatefulWidget {
  final AppUserModel user;
  _ApplicantCard({required this.user});

  @override
  __ApplicantCardState createState() => __ApplicantCardState();
}

class __ApplicantCardState extends State<_ApplicantCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      color: Color.fromARGB(255, 54, 195, 171),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 240, 240, 240),
          ),
          child: ClipOval(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.network(
                widget.user.uprofilephoto ?? 'https://via.placeholder.com/150',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
        title: Text(
          '${widget.user.uname} ${widget.user.usurname}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.user.uemail ?? "",
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_more : Icons.expand_less,
          color: Colors.white,
        ),
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.white),
          ),
          ListTile(
            title: Text('Email: ${widget.user.uemail ?? "N/A"}'),
          ),
          ListTile(
            title: Text('Phone: ${widget.user.uphone ?? "N/A"}'),
          ),
          ListTile(
            title: Text('Birthdate: ${widget.user.ubirthdate ?? "N/A"}'),
          ),
        ],
      ),
    );
  }
}
