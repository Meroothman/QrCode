import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/app_constants.dart';

class ToastUtils {
  static final FToast _fToast = FToast();

  /// Initialize toast (call this in your screen's initState if using custom toast)
  static void init(BuildContext context) {
    _fToast.init(context);
  }

  /// Show success toast
  static void showSuccess(String message, {BuildContext? context}) {
    if (context != null) {
      _showCustomToast(
        context: context,
        message: message,
        icon: Icons.check_circle,
        backgroundColor: Colors.green,
      );
    } else {
      _showSimpleToast(message, Colors.green);
    }
  }

  /// Show error toast
  static void showError(String message, {BuildContext? context}) {
    if (context != null) {
      _showCustomToast(
        context: context,
        message: message,
        icon: Icons.error,
        backgroundColor: Colors.red,
      );
    } else {
      _showSimpleToast(message, Colors.red);
    }
  }

  /// Show info toast
  static void showInfo(String message, {BuildContext? context}) {
    if (context != null) {
      _showCustomToast(
        context: context,
        message: message,
        icon: Icons.info,
        backgroundColor: AppColors.primary,
      );
    } else {
      _showSimpleToast(message, AppColors.primary);
    }
  }

  /// Show warning toast
  static void showWarning(String message, {BuildContext? context}) {
    if (context != null) {
      _showCustomToast(
        context: context,
        message: message,
        icon: Icons.warning,
        backgroundColor: Colors.orange,
      );
    } else {
      _showSimpleToast(message, Colors.orange);
    }
  }

  /// Show custom designed toast
  static void _showCustomToast({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    final fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  /// Show simple toast (fallback if no context available)
  static void _showSimpleToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Cancel all toasts
  static void cancelAllToasts() {
    _fToast.removeCustomToast();
  }
}