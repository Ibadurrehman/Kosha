import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Maps a space's stored `iconKey` to a real symbol.
///
/// The key is stored, never the icon, for the reason `category_icons.dart`
/// gives: `IconData` constants are tree-shaken by reference, so a persisted
/// code point stops rendering the moment the last Dart mention of that icon is
/// deleted. Anything unrecognised — including a key written by a future
/// version — falls back to the folder icon rather than crashing.
IconData spaceIcon(String? key) => switch (key) {
      'home_work' => Symbols.home_work_rounded,
      'wallet' => Symbols.account_balance_wallet_rounded,
      'directions_car' => Symbols.directions_car_rounded,
      'folder_shared' => Symbols.folder_shared_rounded,
      'shopping_basket' => Symbols.shopping_basket_rounded,
      'health' => Symbols.health_and_safety_rounded,
      'flight' => Symbols.flight_takeoff_rounded,
      'flag' => Symbols.flag_rounded,
      'sticky_note' => Symbols.sticky_note_2_rounded,
      'lightbulb' => Symbols.lightbulb_rounded,
      'school' => Symbols.school_rounded,
      'pets' => Symbols.pets_rounded,
      'work' => Symbols.work_rounded,
      'family' => Symbols.family_restroom_rounded,
      'celebration' => Symbols.celebration_rounded,
      'folder' => Symbols.folder_rounded,
      _ => Symbols.folder_rounded,
    };
