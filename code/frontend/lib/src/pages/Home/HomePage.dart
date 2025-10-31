import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

import 'package:frontend/src/routes/AppRoutes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            MoonFilledButton(
              onTap: () => Navigator.pushNamed(context, AppRoutes.details),
              label: const Text('Open details'),
            ),
          ],
        ),
      ),
    );
  }
}
