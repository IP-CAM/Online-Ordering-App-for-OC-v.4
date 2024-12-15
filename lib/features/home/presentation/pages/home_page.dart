import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/features/auth/presentation/bloc/auth_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const ThemeModeFAB(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home Page',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            IconButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                },
                icon: const Icon(
                  Icons.logout,
                ))
          ],
        ),
      ),
    );
  }
}
