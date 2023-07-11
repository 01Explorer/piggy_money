import 'package:piggy_money/models/interfaces/entry_category.dart';

abstract class Entry {
  double amount;
  EntryCategory category;

  Entry({required this.amount, required this.category});

  void changeCategory(EntryCategory newCategory) => category = newCategory;

  void changeAmount(double newAmount) => amount = newAmount;
}
