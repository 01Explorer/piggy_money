import 'package:flutter/material.dart';

interface class EntryCategory {
  final String categoryName;
  final IconData categoryIcon;

  EntryCategory(this.categoryName, this.categoryIcon);
}
