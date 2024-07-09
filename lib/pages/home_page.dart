import 'package:flutter/material.dart';
import 'log_monitor_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PageView for switching between pages
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Container(color: Colors.red),
          const LogMonitorPage(), // LogMonitorPage
        ],
      ),
      // BottomNavigationBar for page navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.monitor), label: 'Log Monitor'),
        ],
      ),
    );
  }
}
