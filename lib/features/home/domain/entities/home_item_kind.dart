/// What kind of record a Home aggregator item points back to.
///
/// Home's sections never depend on another feature's screens or route
/// strings directly (section 4.2's layering rule) — an item only carries its
/// kind and id, and the presentation layer maps that pair to a route. Adding
/// Bills/Documents adapters in later phases means adding a value here plus one
/// switch case in `home_item_routing.dart`, nothing else.
enum HomeItemKind { task }
