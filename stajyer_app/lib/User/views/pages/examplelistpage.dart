// import 'package:flutter/material.dart';
// import 'package:stajyer_app/models/homeAdvModel.dart';
// import 'package:stajyer_app/services/api/homeAdvService.dart';

// class AdvertListScreen extends StatefulWidget {
//   @override
//   _AdvertListScreenState createState() => _AdvertListScreenState();
// }

// class _AdvertListScreenState extends State<AdvertListScreen> {
//   late Future<List<HomeAdvModel>> futureAdverts;

//   @override
//   void initState() {
//     super.initState();
//     futureAdverts = AdvertService().fetchAdverts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('İlanlar'),
//       ),
//       body: FutureBuilder<List<HomeAdvModel>>(
//         future: futureAdverts,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Hiç ilan bulunamadı'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final advert = snapshot.data![index];
//                 return ListTile(
//                   title: Text(advert.advTitle ?? 'İlan Başlığı Yok'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Şirket: ${advert.comp?.compName ?? 'Şirket Adı Yok'}'),
//                       Text('Konum: ${advert.advAdress ?? 'Konum Yok'}'),
//                       Text('Açıklama: ${advert.advDesc ?? 'Açıklama Yok'}'),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
