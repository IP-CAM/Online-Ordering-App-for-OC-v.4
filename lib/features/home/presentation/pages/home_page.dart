import 'package:flutter/material.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
Future.delayed(Durations.medium1, (){
  Loader.show(context);
});
Future.delayed(const Duration(seconds: 3,), (){
  Loader.hide();
});

    
  }
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
