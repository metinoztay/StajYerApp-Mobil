import 'package:flutter/material.dart';
import 'package:stajyer_app/User/models/CertificateModel.dart';
import 'package:stajyer_app/User/services/api/CertificateService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/AddCertificate.dart';

class UserCertificateWidget extends StatefulWidget {
  final int userId;

  const UserCertificateWidget({Key? key, required this.userId})
      : super(key: key);

  @override
  State<UserCertificateWidget> createState() => _UserCertificateWidgetState();
}

class _UserCertificateWidgetState extends State<UserCertificateWidget> {
  List<CertificateModel> certificates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCertificates();
  }

  Future<void> _fetchCertificates() async {
    try {
      List<CertificateModel> fetchedCertificates =
          await CertificateService().GetUserCertificates(widget.userId);
      setState(() {
        certificates = fetchedCertificates;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching certificates: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showAddCertificateDialog() async {
    bool? result = await showAddCertificateDialog(context);
    if (result ?? false) {
      _fetchCertificates(); // Refresh certificates after adding a new one
    }
  }

  Future<void> _deleteCertificate(int? certificateId) async {
    if (certificateId != null) {
      try {
        await CertificateService().deleteCertificate(certificateId);
        setState(() {
          certificates.removeWhere(
              (certificate) => certificate.certId == certificateId);
        });
      } catch (error) {
        print("Error deleting certificate: $error");
      }
    } else {
      print('Certificate ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = background;
    final buttonColor = ilanCard; // Custom user-defined color

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (certificates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sertifikalarınız bulunmamaktadır.",
              style: TextStyle(color: buttonColor),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 40),
                backgroundColor: ilanCard,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: _showAddCertificateDialog,
              child: Text('Yeni Sertifika Ekle'),
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
                    'Sertifikalarım',
                    style: TextStyle(
                      color: buttonColor,
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
                    onPressed: _showAddCertificateDialog,
                    child: Text('Yeni Sertifika'),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: certificates.length,
                  itemBuilder: (context, index) {
                    final certificate = certificates[index];
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
                                  certificate.certName ?? "Sertifika Adı",
                                  style: TextStyle(
                                      color: buttonColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  certificate.certDesc ??
                                      "Sertifika Açıklaması",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: buttonColor),
                            onPressed: () {
                              _deleteCertificate(certificate.certId);
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
