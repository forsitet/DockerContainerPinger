// ignore_for_file: deprecated_member_use

import 'package:exapmle_docker_pinger/src/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.lightAccentColor,
    background: AppColors.backgroundColorLight,
    surface: AppColors.cardColorLight,
    onBackground: AppColors.textColorLight,
    onSurface: AppColors.textColorLight,
  ),
  scaffoldBackgroundColor: AppColors.backgroundColorLight,
  cardColor: AppColors.cardColorLight,
  dividerColor: AppColors.borderColorLight,
);

ThemeData darkTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryColor,
    secondary: AppColors.darkAccentColor,
    background: AppColors.backgroundColorDark,
    surface: AppColors.cardColorDark,
    onBackground: AppColors.textColorDark,
    onSurface: AppColors.textColorDark,
  ),
  scaffoldBackgroundColor: AppColors.backgroundColorDark,
  cardColor: AppColors.cardColorDark,
  dividerColor: AppColors.borderColorDark,
);
