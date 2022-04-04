import 'package:dory/components/dory_colors.dart';
import 'package:dory/components/dory_constants.dart';
import 'package:dory/pages/add/add_medicinepage.dart';
import 'package:dory/pages/history/history_page.dart';
import 'package:dory/pages/today/today_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  final _pages = [
    const TodayPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pagePadding,
        child: SafeArea(child: _pages[_currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMedicine,
        child: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
        child: Container(
            height: kBottomNavigationBarHeight,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  onPressed: () => _onCurrentPage(0),
                  child: Icon(
                    CupertinoIcons.check_mark,
                    color: _currentIndex == 0
                        ? DoryColors.primaryColor
                        : Colors.grey[350],
                  ),
                ),
                CupertinoButton(
                  onPressed: () => _onCurrentPage(1),
                  child: Icon(
                    CupertinoIcons.text_badge_checkmark,
                    color: _currentIndex == 1
                        ? DoryColors.primaryColor
                        : Colors.grey[350],
                  ),
                ),
              ],
            )));
  }

  void _onCurrentPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }

  void _onAddMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMedicinePage()),
    );
  }
}
