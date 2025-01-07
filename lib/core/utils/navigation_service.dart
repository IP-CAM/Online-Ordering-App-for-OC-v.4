import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  // General navigation methods
  static void push(
    BuildContext context,
    String location,
  ) {
    context.push(location);
  }

  static void pop(BuildContext context) {
    context.pop();
  }

  static void pushReplacement(
    BuildContext context,
    String location,
  ) {
    context.pushReplacement(location);
  }

  // Navigate with query parameters
  static void pushWithQuery(
    BuildContext context,
    String location,
    Map<String, dynamic> queryParams,
  ) {
    context.push(location, extra: queryParams);
  }

  // Navigate with query parameters
  static void pushReplacementWithQuery(
    BuildContext context,
    String location,
    Map<String, String> queryParams,
  ) {
    context.pushReplacement(location, extra: queryParams);
  }
}
