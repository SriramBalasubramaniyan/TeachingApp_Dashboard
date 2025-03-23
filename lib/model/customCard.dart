import 'package:flutter/cupertino.dart';

class CustomCardModel {
  final String leadingLabel;
  final IconData? leadingIcon;
  final String trialLabel;
  final bool showDropdown;
  final Widget child;

  const CustomCardModel({
    required this.leadingLabel,
    required this.trialLabel,
    required this.child,
    this.leadingIcon,
    required this.showDropdown,
  });
}