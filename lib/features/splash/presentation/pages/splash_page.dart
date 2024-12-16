import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/config/theme/custom_colors.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/splash/presentation/bloc/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SplashBloc>(context).add(FetchMenuEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashSuccess) {
            NavigationService.pushReplacement(
              context,
              RouteConstants.home,
            );
          }
          if (state is SplashFailure) {
            showCustomSnackBar(
              context: context,
              message: state.error,
              type: SnackBarType.error,
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: appColors.primary,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 300,
                  height: 300,
                ),
                SpinKitFadingCube(
                  color: appColors.surfaceLight,
                  size: 100.0,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
