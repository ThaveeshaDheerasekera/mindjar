import 'package:flutter/material.dart';
import 'package:mindjar/configs/Constants.dart';
import 'package:mindjar/configs/custom_colors.dart';
import 'package:mindjar/screens/favorite_screen.dart';
import 'package:mindjar/screens/home_screen.dart';
import 'package:mindjar/screens/user_details_screen.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({super.key});

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _currentIndex = 0; // Initial index of the selected tab

  // This is the list of screens available
  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoriteScreen(),
    const UserDetailsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // This scaffold is called in the main file
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: Constants.screenSize(context).height,
          color: CustomColors.background,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: CustomColors.olive,
          unselectedItemColor: Colors.black.withOpacity(0.25),
          selectedItemColor: Theme.of(context).primaryColor,
          showSelectedLabels: false, // Hide selected labels
          showUnselectedLabels: false, // Hide unselected labels
          currentIndex: _currentIndex,
          // When an item of the bottom navbar is clicked,
          // the _currentIndex variable will be updated to the new index
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            // Home screen
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 25),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 25),
              label: 'Favorite',
            ), // User information screen
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box, size: 25),
              label: 'User Info',
            ),
          ],
        ),
      ),
    );
  }
}
