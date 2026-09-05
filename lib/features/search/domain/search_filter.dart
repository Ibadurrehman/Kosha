/// The 6 filter chips on the Search screen. Only [everything] and [tasks]
/// return real results today — the rest render for visual fidelity and show
/// their own "not built yet" empty state (see `SearchRepository.supports`).
enum SearchFilter {
  everything('Everything'),
  tasks('Tasks'),
  notes('Notes'),
  documents('Documents'),
  finance('Finance'),
  spaces('Spaces');

  const SearchFilter(this.label);

  final String label;
}
