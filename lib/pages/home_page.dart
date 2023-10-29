import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tech_knowl_edge_connect/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;
  final List<Widget> _tabs = const <Widget>[
    Text('Home'),
    Text('Suche'),
    Text('Bibliothek'),
    ProfilePage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: IndexedStack(children: [
        Center(
          child: _tabs.elementAt(_currentIndex),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(label: 'Suche', icon: Icon(Icons.search)),
          BottomNavigationBarItem(
              label: 'Bibliothek', icon: Icon(Icons.library_books)),
          BottomNavigationBarItem(label: 'Profil', icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
}
