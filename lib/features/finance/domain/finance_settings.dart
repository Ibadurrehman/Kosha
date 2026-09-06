import '../../../core/services/settings/settings_store.dart';

/// The income fallback from ADR 0006 (D4): shown on Finance's "This month"
/// card only while the month has no income transaction, so the dashboard
/// never reads ₹0 for a brand-new user.
const String monthlyBudgetMinorKey = 'finance.monthly_budget_minor';

/// Minor units (paise), or null if the user has never set one.
Future<int?> readMonthlyBudgetMinor(SettingsStore store) =>
    store.read(monthlyBudgetMinorKey, (json) => json as int);

Future<void> writeMonthlyBudgetMinor(SettingsStore store, int minorUnits) =>
    store.write(monthlyBudgetMinorKey, minorUnits);
