import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

class KhedmaApp extends StatelessWidget {
  const KhedmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(body: Center(child: Text('Khedma'))),
    );
  }
}
