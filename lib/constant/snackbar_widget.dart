import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarWidget {
  snackbar(String title, error) {
    Get.snackbar(
      title,
      error,
      colorText: Colors.black,
      backgroundColor: Colors.white,
    );
  }
}
