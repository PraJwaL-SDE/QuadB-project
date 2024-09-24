import 'package:flutter/material.dart';
import 'package:quadb_tech_assignment/pages/home_screen.dart';
import 'package:quadb_tech_assignment/pages/search_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  Widget searchScreen() {
    return SearchScreen();
  }

  Widget downloadsScreen() {
    return const Center(child: Text('Downloads Screen'));
  }

  Widget profileScreen() {
    return const Center(child: Text('Profile Screen'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // IndexedStack to switch between different screens based on _currentIndex
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          searchScreen(),
          downloadsScreen(),
          profileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black, // Dark background for bottom navigation
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Downloads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      backgroundColor: Colors.black, // Dark background for the entire screen
    );
  }
}
