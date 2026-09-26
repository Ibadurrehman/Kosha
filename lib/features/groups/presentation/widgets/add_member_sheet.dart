import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/group_repository_impl.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/group_member.dart';
import '../controllers/group_providers.dart';
import '../group_actions.dart';
import 'member_avatar.dart';

/// "Invite" in v1: a name, typed (§6.14).
///
/// Phase 5 turns this into a share link and a real account behind each
/// member. Until then the sheet says so, because a button called Invite that
/// only added a name locally would be promising something the app cannot do.
Future<void> showAddMemberSheet(
  BuildContext context, {
  required String groupId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => AddMemberSheet(groupId: groupId),
  );
}

class AddMemberSheet extends ConsumerStatefulWidget {
  const AddMemberSheet({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends ConsumerState<AddMemberSheet> {
  late final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canAdd => _name.text.trim().isNotEmpty;

  Future<void> _add() async {
    if (!_canAdd) return;
    final name = _name.text.trim();
    final repository = ref.read(groupRepositoryProvider);

    await repository.addMember(
      widget.groupId,
      NewGroupMember(displayName: name),
    );
    if (!mounted) return;
    _name.clear();
    ref.read(toastControllerProvider.notifier).show('Added $name');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final members = ref.watch(groupMembersProvider(widget.groupId)).value ??
        const <GroupMember>[];

    return SheetScaffold(
      title: 'Who else is in?',
      subtitle: 'Names only for now — sharing a group with their own phone '
          'arrives with accounts.',
      children: [
        TextField(
          controller: _name,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => unawaited(_add()),
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Aarav Sharma',
          ),
        ),
        const SizedBox(height: KoshaSpace.md),
        FilledButton(
          onPressed: _canAdd ? () => unawaited(_add()) : null,
          child: const Text('Add to the group'),
        ),
        const SizedBox(height: KoshaSpace.xl),
        Text('In this group', style: t.labelLarge),
        const SizedBox(height: KoshaSpace.sm),
        for (final member in members)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                MemberAvatar(member: member, size: 30),
                const SizedBox(width: KoshaSpace.md),
                Expanded(
                  child: Text(
                    member.isSelf ? '${member.displayName} (you)' : member.displayName,
                    style: t.bodyMedium,
                  ),
                ),
                if (member.isSelf)
                  Text(
                    member.role.role,
                    style: t.bodySmall?.copyWith(color: c.text3),
                  )
                else
                  TextButton(
                    onPressed: () =>
                        unawaited(removeMember(context, ref, member)),
                    style: TextButton.styleFrom(foregroundColor: c.text2),
                    child: const Text('Remove'),
                  ),
              ],
            ),
          ),
        const SizedBox(height: KoshaSpace.sm),
      ],
    );
  }
}

/// Creates a group in a space, from the card that offers to start one.
Future<void> showNewGroupSheet(
  BuildContext context, {
  required String spaceId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => NewGroupSheet(spaceId: spaceId),
  );
}

class NewGroupSheet extends ConsumerStatefulWidget {
  const NewGroupSheet({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<NewGroupSheet> createState() => _NewGroupSheetState();
}

class _NewGroupSheetState extends ConsumerState<NewGroupSheet> {
  late final TextEditingController _name = TextEditingController();
  DateTimeRange? _dates;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canCreate => _name.text.trim().isNotEmpty;

  Future<void> _pickDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _dates,
    );
    if (picked != null && mounted) setState(() => _dates = picked);
  }

  Future<void> _create() async {
    if (!_canCreate) return;
    final repository = ref.read(groupRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final name = _name.text.trim();

    Navigator.of(context).pop();

    final group = await repository.createGroup(
      NewGroup(
        name: name,
        spaceId: widget.spaceId,
        startsOn: _dates?.start,
        endsOn: _dates?.end,
      ),
    );
    toast.show(
      'Started “$name”',
      onUndo: () => unawaited(repository.deleteGroup(group.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return SheetScaffold(
      title: 'Start a group',
      subtitle: 'Split what a trip or a flat costs, and see who owes what.',
      children: [
        TextField(
          controller: _name,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Goa',
          ),
        ),
        const SizedBox(height: KoshaSpace.md),
        InkWell(
          onTap: () => unawaited(_pickDates()),
          borderRadius: BorderRadius.circular(KoshaRadius.input),
          child: InputDecorator(
            decoration: const InputDecoration(labelText: 'Dates (optional)'),
            child: Text(
              _dates == null
                  ? 'Not set'
                  : '${_dates!.start.day}/${_dates!.start.month} — '
                      '${_dates!.end.day}/${_dates!.end.month}',
              style: TextStyle(color: _dates == null ? c.text2 : c.text),
            ),
          ),
        ),
        const SizedBox(height: KoshaSpace.md),
        Text(
          'You are in it from the start. Add everybody else once it exists.',
          style: t.bodySmall?.copyWith(color: c.text3),
        ),
        const SizedBox(height: KoshaSpace.lg),
        FilledButton(
          onPressed: _canCreate ? () => unawaited(_create()) : null,
          child: const Text('Start the group'),
        ),
      ],
    );
  }
}
