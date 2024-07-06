import 'package:flutter/material.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppPallete.gradient1,
      ),
    );
  }
}
