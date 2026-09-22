import 'package:flutter/material.dart';

import '../../../../core/theme/kosha_shapes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/document.dart';
import '../document_labels.dart';

/// The fields Add document and Edit document both collect (section 6.8).
///
/// A controller rather than a pile of callbacks, so the two screens share
/// validity and drafting rules instead of each deciding when Save lights up —
/// the shape `BillFormController` already set.
class DocumentFormController extends ChangeNotifier {
  DocumentFormController({Document? existing})
      : name = TextEditingController(text: existing?.name ?? ''),
        number = TextEditingController(text: existing?.number ?? ''),
        notes = TextEditingController(text: existing?.notes ?? ''),
        _category = existing?.category ?? DocumentCategory.identity,
        _issuedOn = existing?.issuedOn,
        _expiresOn = existing?.expiresOn,
        _reminderOffsetDays =
            existing?.reminderOffsetDays ?? defaultDocumentReminderDays {
    name.addListener(notifyListeners);
  }

  final TextEditingController name;
  final TextEditingController number;
  final TextEditingController notes;

  DocumentCategory _category;
  DateTime? _issuedOn;
  DateTime? _expiresOn;
  int _reminderOffsetDays;

  DocumentCategory get category => _category;
  DateTime? get issuedOn => _issuedOn;
  DateTime? get expiresOn => _expiresOn;
  int get reminderOffsetDays => _reminderOffsetDays;

  /// Only the name is required: a document the user has just scanned and not
  /// yet labelled is still worth keeping, and every other field is something
  /// they may not have to hand.
  bool get isValid => name.text.trim().isNotEmpty;

  set category(DocumentCategory value) {
    _category = value;
    notifyListeners();
  }

  set issuedOn(DateTime? value) {
    _issuedOn = value;
    notifyListeners();
  }

  set expiresOn(DateTime? value) {
    _expiresOn = value;
    notifyListeners();
  }

  set reminderOffsetDays(int value) {
    _reminderOffsetDays = value;
    notifyListeners();
  }

  NewDocument toDraft({String? spaceId}) => NewDocument(
        name: name.text.trim(),
        category: _category,
        number: _trimmedOrNull(number),
        issuedOn: _issuedOn,
        expiresOn: _expiresOn,
        reminderOffsetDays: _reminderOffsetDays,
        notes: _trimmedOrNull(notes),
        spaceId: spaceId,
      );

  String? _trimmedOrNull(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  @override
  void dispose() {
    name
      ..removeListener(notifyListeners)
      ..dispose();
    number.dispose();
    notes.dispose();
    super.dispose();
  }
}

class DocumentFormFields extends StatelessWidget {
  const DocumentFormFields({
    super.key,
    required this.controller,
    required this.today,
  });

  final DocumentFormController controller;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller.name,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Passport, Rent agreement…',
          ),
        ),
        const SizedBox(height: KoshaSpace.lg),
        Text('Category', style: t.labelLarge),
        const SizedBox(height: KoshaSpace.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final category in DocumentCategory.values)
              KoshaChip(
                label: category.label,
                icon: documentCategoryIcon(category),
                selected: controller.category == category,
                onTap: () => controller.category = category,
              ),
          ],
        ),
        const SizedBox(height: KoshaSpace.lg),
        TextField(
          controller: controller.number,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Number',
            hintText: 'Policy or document number (optional)',
          ),
        ),
        const SizedBox(height: KoshaSpace.md),
        _DateRow(
          label: 'Issued on',
          value: controller.issuedOn,
          today: today,
          onPick: (date) => controller.issuedOn = date,
          onClear: () => controller.issuedOn = null,
        ),
        _DateRow(
          label: 'Expires on',
          value: controller.expiresOn,
          today: today,
          onPick: (date) => controller.expiresOn = date,
          onClear: () => controller.expiresOn = null,
        ),
        if (controller.expiresOn != null) ...[
          const SizedBox(height: KoshaSpace.md),
          Text('Remind me', style: t.labelLarge),
          const SizedBox(height: KoshaSpace.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final days in documentReminderLeadChoices)
                KoshaChip(
                  label: reminderLeadLabel(days),
                  selected: controller.reminderOffsetDays == days,
                  onTap: () => controller.reminderOffsetDays = days,
                ),
            ],
          ),
          const SizedBox(height: KoshaSpace.sm),
          Text(
            'It will also appear under Needs attention on Home.',
            style: t.bodySmall,
          ),
        ],
        const SizedBox(height: KoshaSpace.md),
        TextField(
          controller: controller.notes,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Notes',
            hintText: 'Where it is kept, who to call (optional)',
          ),
        ),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.value,
    required this.today,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final DateTime today;
  final ValueChanged<DateTime> onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final current = value;

    return Row(
      children: [
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        TextButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: current ?? today,
              // Wide enough for a certificate from decades ago and a policy
              // that runs for decades yet.
              firstDate: DateTime(today.year - 60),
              lastDate: DateTime(today.year + 60),
            );
            if (picked != null) {
              onPick(DateTime(picked.year, picked.month, picked.day));
            }
          },
          child: Text(current == null ? 'Set' : Dates.dayMonthYear(current)),
        ),
        if (current != null)
          IconButton(
            onPressed: onClear,
            tooltip: 'Clear $label',
            icon: const Icon(Icons.close_rounded, size: 18),
          ),
      ],
    );
  }
}
