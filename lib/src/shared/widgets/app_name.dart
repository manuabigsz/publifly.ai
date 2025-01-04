import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppNameWidget extends StatelessWidget {
  const AppNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Publi',
          style: TextStyle(
            color: AppColors.logoColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text(
          'fly',
          style: TextStyle(
            color: AppColors.greenColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text(
          '.ai',
          style: TextStyle(
            color: AppColors.purpleColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
