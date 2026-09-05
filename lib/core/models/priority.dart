/// Task priority.
///
/// Persisted by index in SQLite — append new values, never reorder.
enum Priority {
  none('None'),
  low('Low'),
  medium('Medium'),
  high('High');

  const Priority(this.label);

  final String label;

  /// False for [Priority.none], which is never shown as a dot or a chip.
  bool get isSet => this != Priority.none;
}
