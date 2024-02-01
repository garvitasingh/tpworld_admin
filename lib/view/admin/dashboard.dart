import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/colors.dart';
import 'admin_home.dart';
import 'setting.dart';
import 'users_listView.dart';

class DashBoardView extends StatefulWidget {
  int index;
  DashBoardView({super.key, required this.index});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _currentIndex = widget.index;
    super.initState();
  }

  int _currentIndex = 0;
  final _bottomNavBarItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: const Icon(Icons.person),
      label: 'Users',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Setting',
    ),
  ];

  final List<Widget> _pages = [
    const AdminHomePageView(),
    const UsersListView(),
    SettingView()
  ];

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    //var w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      //  drawer: CustomDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff334D8F),
        elevation: 5,
        currentIndex: _currentIndex,
        items: _bottomNavBarItems,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        selectedItemColor: Colors.white,
        unselectedItemColor: BLUE300_COLOR,
        onTap: (index) {
          if (index == 4) {
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}
