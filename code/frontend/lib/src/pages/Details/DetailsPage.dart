import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:moon_design/moon_design.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(title: Text(AppLocalizations.of(context)?.detailsTitle ?? 'Details')),
      body: SingleChildScrollView(
        child: MoonButton(label: const Text('A Moon Design Button'), onTap: () => {print('test')},),
      ),
    );
  }
}
