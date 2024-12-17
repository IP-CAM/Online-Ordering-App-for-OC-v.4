import 'package:flutter/material.dart';

enum SnackBarType {
  info,
  success,
  warning,
  error,
}

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.info,
  int? duration,
  SnackBarAction? action,
}) {
  final colors = {
    SnackBarType.info: Colors.blue,
    SnackBarType.success: Colors.green,
    SnackBarType.warning: Colors.orange,
    SnackBarType.error: Colors.red,
  };

  final icons = {
    SnackBarType.info: Icons.info_outline,
    SnackBarType.success: Icons.check_circle_outline,
    SnackBarType.warning: Icons.warning_amber_outlined,
    SnackBarType.error: Icons.error_outline,
  };

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          icons[type],
          color: Colors.white,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: colors[type],
    duration: Duration(seconds: duration ?? 2),
    action: action,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    margin: const EdgeInsets.all(8),
    
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}