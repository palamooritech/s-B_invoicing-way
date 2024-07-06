import 'package:flutter/material.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';

class AppTheme{

  static _authTBBorder([Color color = AppPallete.borderColor]) => OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(10)
  );

  static _defaultTextStyle() => const TextStyle(
    fontFamily: 'Space Grotesk',
    color: AppPallete.primaryFontColor// Replace with your desired font family
  );

  static TextTheme get textTheme {
    return TextTheme(
        bodyMedium: _defaultTextStyle(),
        bodySmall: _defaultTextStyle(),
        titleLarge: _defaultTextStyle(),
        titleMedium: _defaultTextStyle(),
        bodyLarge: _defaultTextStyle(),
        labelSmall: _defaultTextStyle(),
        labelMedium: _defaultTextStyle(),
        labelLarge: _defaultTextStyle(),
    );
  }

  static final lightThemeMode = ThemeData.light().copyWith(
    textTheme: textTheme,
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.gradient1,
      titleTextStyle: TextStyle(
        color: AppPallete.whiteColor,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        fontFamily:'Space Grotesk',
      ),
      actionsIconTheme: IconThemeData(
        color: AppPallete.whiteColor,
        size: 40
      )
    ),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27.0),
          hintStyle: _defaultTextStyle(),
          border: _authTBBorder(),
          enabledBorder: _authTBBorder(),
          focusedBorder: _authTBBorder(AppPallete.gradient2),
          errorBorder: _authTBBorder(AppPallete.errorColor)
      )
  );


}