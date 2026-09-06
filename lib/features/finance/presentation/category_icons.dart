import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Maps a category's stored `iconKey` to a real symbol.
///
/// The key is stored, never the icon: `IconData` constants are tree-shaken by
/// reference, so a persisted code point stops rendering the moment the last
/// Dart mention of that icon is deleted. Anything unrecognised — including a
/// key written by a future version — falls back to the folder icon rather
/// than crashing.
IconData categoryIcon(String? key) => switch (key) {
      'shopping_basket' => Symbols.shopping_basket_rounded,
      'restaurant' => Symbols.restaurant_rounded,
      'train' => Symbols.train_rounded,
      'receipt' => Symbols.receipt_long_rounded,
      'shopping_bag' => Symbols.shopping_bag_rounded,
      'health' => Symbols.health_and_safety_rounded,
      'movie' => Symbols.live_tv_rounded,
      'home' => Symbols.home_rounded,
      'school' => Symbols.school_rounded,
      'pets' => Symbols.pets_rounded,
      'savings' => Symbols.savings_rounded,
      'more' => Symbols.more_horiz_rounded,
      _ => Symbols.folder_rounded,
    };
