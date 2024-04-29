import 'package:calculate_card_score/core/constants/app_const.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: textColor, thickness: 1, height: 1);
  }
}