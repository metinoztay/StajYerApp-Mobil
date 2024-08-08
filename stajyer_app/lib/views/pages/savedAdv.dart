import 'package:flutter/material.dart';
import 'package:stajyer_app/views/components/basvurulanlar.dart';
import 'package:stajyer_app/views/components/kaydedilenler.dart';

class SavedAdv extends StatefulWidget {
  const SavedAdv({super.key});

  @override
  State<SavedAdv> createState() => _SavedAdvState();
}

class _SavedAdvState extends State<SavedAdv>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SavedListPage savedListPage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    savedListPage = SavedListPage();

    // Listener ekleyerek tab değişikliklerini dinliyoruz
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        setState(() {
          // SavedListPage'i yeniden oluştur
          savedListPage = SavedListPage();
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'kaydedilenler'),
              Tab(text: 'Başvurulanlar'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                savedListPage,
                AppliedAdvertsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
