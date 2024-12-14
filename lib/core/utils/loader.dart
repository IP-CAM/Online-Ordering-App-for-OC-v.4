import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ordering_app/config/theme/custom_colors.dart';

class Loader {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Container(
            color: appColors.semiTransparent,
            child: Center(
              child: SpinKitWaveSpinner(
                color: appColors.primary,
                size: 100.0,
                waveColor: appColors.secondary,
                trackColor: Theme.of(context).splashColor,
                // lineWidth: 5,
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
