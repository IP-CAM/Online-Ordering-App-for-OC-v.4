import 'package:flutter/material.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const ThemeModeFAB(),
      body: Center(
        child: Text(
          'Home Page',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
