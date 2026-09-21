import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../domain/entities/space.dart';
import '../space_icons.dart';

/// What the New space sheet hands back, or null if it was dismissed.
class NewSpaceResult {
  const NewSpaceResult({
    required this.name,
    required this.iconKey,
    required this.holds,
  });

  final String name;
  final String? iconKey;
  final Set<SpaceHolds> holds;
}

/// Name, icon and "what can it hold" (Appendix A's New space screen).
///
/// Also edits an existing space when [space] is given — Space settings needs
/// exactly these three fields, and a second sheet that looked identical would
/// be the same widget with a different title.
Future<NewSpaceResult?> showNewSpaceSheet(
  BuildContext context, {
  Space? space,
}) {
  return showModalBottomSheet<NewSpaceResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => NewSpaceSheet(space: space),
  );
}

class NewSpaceSheet extends StatefulWidget {
  const NewSpaceSheet({super.key, this.space});

  final Space? space;

  @override
  State<NewSpaceSheet> createState() => _NewSpaceSheetState();
}

class _NewSpaceSheetState extends State<NewSpaceSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.space?.name ?? '');
  late String? _iconKey = widget.space?.iconKey ?? newSpaceIconPicks.first;
  late final Set<SpaceHolds> _holds = {
    ...widget.space?.holds ?? defaultNewSpaceHolds,
  };

  bool get _isValid => _name.text.trim().isNotEmpty;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  /// A system space's icon is offered alongside the eight picks, so editing
  /// Finance does not silently re-icon it just by opening the sheet.
  List<String> get _iconChoices {
    final current = _iconKey;
    if (current == null || newSpaceIconPicks.contains(current)) {
      return newSpaceIconPicks;
    }
    return [current, ...newSpaceIconPicks];
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final editing = widget.space != null;

    return SheetScaffold(
      title: editing ? 'Space settings' : 'New space',
      children: [
        const SizedBox(height: 6),
        TextField(
          controller: _name,
          autofocus: !editing,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Travel, Work, Health…',
          ),
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: KoshaSpace.xl),
        Text('Icon', style: t.labelLarge),
        const SizedBox(height: KoshaSpace.md),
        Wrap(
          spacing: KoshaSpace.md,
          runSpacing: KoshaSpace.md,
          children: [
            for (final key in _iconChoices)
              _IconPick(
                iconKey: key,
                selected: key == _iconKey,
                onTap: () => setState(() => _iconKey = key),
              ),
          ],
        ),
        const SizedBox(height: KoshaSpace.xl),
        Text('What can it hold', style: t.labelLarge),
        const SizedBox(height: 4),
        Text(
          'This decides where the space is offered — a space that holds '
          'expenses shows up in the New expense sheet.',
          style: t.bodySmall?.copyWith(color: c.text3),
        ),
        const SizedBox(height: KoshaSpace.md),
        Wrap(
          spacing: KoshaSpace.sm,
          runSpacing: KoshaSpace.sm,
          children: [
            for (final hold in SpaceHolds.values)
              FilterChip(
                label: Text(hold.label),
                selected: _holds.contains(hold),
                onSelected: (on) => setState(() {
                  on ? _holds.add(hold) : _holds.remove(hold);
                }),
              ),
          ],
        ),
        const SizedBox(height: KoshaSpace.xxl),
        Row(
          children: [
            IconButton(
              onPressed: Navigator.of(context).pop,
              tooltip: 'Cancel',
              icon: const Icon(Symbols.close_rounded),
            ),
            const SizedBox(width: KoshaSpace.sm),
            Expanded(
              child: FilledButton(
                onPressed: _isValid ? _submit : null,
                child: Text(editing ? 'Save changes' : 'Create'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _submit() {
    if (!_isValid) return;
    Navigator.of(context).pop(
      NewSpaceResult(
        name: _name.text.trim(),
        iconKey: _iconKey,
        holds: _holds,
      ),
    );
  }
}

class _IconPick extends StatelessWidget {
  const _IconPick({
    required this.iconKey,
    required this.selected,
    required this.onTap,
  });

  final String iconKey;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Semantics(
      button: true,
      selected: selected,
      label: iconKey.replaceAll('_', ' '),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KoshaRadius.chip),
        child: Container(
          width: KoshaSize.minTap,
          height: KoshaSize.minTap,
          decoration: BoxDecoration(
            color: selected ? c.accentSoft : c.sunk,
            borderRadius: BorderRadius.circular(KoshaRadius.chip),
            border: Border.all(color: selected ? c.accent : c.hair),
          ),
          child: Icon(
            spaceIcon(iconKey),
            size: 20,
            color: selected ? c.accent : c.text2,
          ),
        ),
      ),
    );
  }
}
