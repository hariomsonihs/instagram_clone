import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/post_provider.dart';
import 'repositories/post_repository.dart';
import 'screens/home_feed_screen.dart';

void main() {
  runApp(const InstagramCloneApp());
}

class InstagramCloneApp extends StatelessWidget {
  const InstagramCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              PostProvider(repository: PostRepository())..loadInitialPosts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Home Feed Clone',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.white,
          ),
          dividerColor: const Color(0xFFE8E8E8),
          useMaterial3: true,
        ),
        home: const HomeFeedScreen(),
      ),
    );
  }
}
