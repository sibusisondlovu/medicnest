import 'package:flutter/material.dart';
import 'package:patient_app/config/theme.dart';
import 'package:patient_app/controllers/main_layout_notifier.dart';
import 'package:patient_app/screens/alerts_screen.dart';
import 'package:patient_app/screens/chats_screen.dart';
import 'package:patient_app/screens/home_screen.dart';
import 'package:patient_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  static const String id = 'mainLayout';
  const MainLayout({
    super.key,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const ChatsScreen(),
    const AlertsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainLayoutNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          body: IndexedStack(
            index: mainScreenNotifier.pageIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Alerts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: mainScreenNotifier.pageIndex,
            selectedItemColor: AppTheme.mainColor,
            unselectedItemColor: Colors.grey,
            onTap: (value){
              mainScreenNotifier.pageIndex = value;
            },
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }
}