import 'package:flutter/material.dart';
import 'package:job/src/core/utils/app_theme.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/icons/Home.png")),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/icons/Work.png")),
          label: 'Jobs',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/icons/mypost.png")),
          label: 'Application',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/icons/Profile.png")),
          label: 'Account',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: AppTheme.primary,
      unselectedItemColor: AppTheme.TextBoldLite,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
    );
  }
}
