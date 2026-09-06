/// The 9 areas offered on the "Pick areas" onboarding step (Appendix A).
///
/// Spaces do not exist yet (Phase 3), so picking areas here only narrows what
/// Home's Quick access and the dashboard talk about; it does not create or
/// hide any real row. Phase 3 is expected to read the stored selection back
/// as the starting visibility for the matching system spaces.
enum OnboardingArea {
  tasks('Tasks'),
  finance('Finance'),
  bills('Bills'),
  documents('Documents'),
  shopping('Shopping'),
  home('Home'),
  vehicle('Vehicle'),
  goals('Goals'),
  notes('Notes');

  const OnboardingArea(this.label);

  final String label;
}
