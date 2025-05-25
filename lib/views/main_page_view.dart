import 'package:flutter/material.dart';
import 'package:musix/views/drawer.dart';
import '../views/sign_up_view.dart';
import '../views/home_view.dart';
import '../views/shop_view.dart';

class MainPage extends StatefulWidget {
  final int tabIndex;
  const MainPage({super.key, this.tabIndex = 1}); // Default: Home

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    SignUpView(),
    HomeView(),
    ShopPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.tabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),
        ],
      ),
    );
  }
}
