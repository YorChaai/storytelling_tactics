import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_session_provider.dart';
import 'screens/catalog_screen.dart';
import 'screens/random_draw_screen.dart';
import 'screens/three_stories_screen.dart';
import 'screens/recipe_screen.dart';
import 'screens/desert_island_screen.dart';
import 'screens/about_system_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameSessionProvider(),
      child: const StorytellerApp(),
    ),
  );
}

class StorytellerApp extends StatelessWidget {
  const StorytellerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storyteller Tactics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6366F1),
          surface: const Color(0xFF1E293B),
        ),
        fontFamily: 'Roboto', // Default flutter font, fits well enough
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    AboutSystemScreen(),
    CatalogScreen(),
    RandomDrawScreen(),
    ThreeStoriesScreen(),
    RecipeScreen(),
    DesertIslandScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storyteller Tactics', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: const Color(0xFF6366F1).withAlpha(128),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.info), label: 'Info'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Catalog'),
          NavigationDestination(icon: Icon(Icons.shuffle), label: 'Draw'),
          NavigationDestination(icon: Icon(Icons.auto_stories), label: '3 Stories'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Recipe'),
          NavigationDestination(icon: Icon(Icons.sailing), label: 'Island'),
        ],
      ),
    );
  }
}
