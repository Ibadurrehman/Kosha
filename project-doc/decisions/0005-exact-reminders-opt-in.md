# ADR 0005 — Exact reminders as an opt-in setting

**Status:** Accepted · 2026-09-06 · resolves plan decision D9

## Decision
Reminders schedule with `AndroidScheduleMode.inexactAllowWhileIdle` by default. A
Settings → Notifications → "Exact reminders" toggle switches every reminder scheduled
from then on to `exactAllowWhileIdle`, after asking Android for the
`SCHEDULE_EXACT_ALARM` permission via `requestExactAlarmsPermission()`. Declining the
OS prompt leaves the setting off. Turning it on or off re-schedules every currently
eligible task/event reminder immediately (`resyncReminders()`), so the mode applies
retroactively rather than only to reminders created afterward. iOS has no equivalent
permission — its reminders already fire at the exact moment — so
`requestExactAlarmsPermission()` returns `true` unconditionally there.

## Why
`SCHEDULE_EXACT_ALARM` is a sensitive Android permission subject to Play Store policy
scrutiny, and most personal-task reminders tolerate the OS's inexact, battery-friendly
delivery window. Defaulting to inexact avoids both the permission prompt and the store
review question for the common case; users who need precise timing opt in explicitly.

## Consequences
- `ReminderScheduler` carries a `setExactAlarmsEnabled`/`requestExactAlarmsPermission`
  pair; `LocalNotificationsReminderScheduler` holds the current mode as instance state
  read by every `schedule()` call. `app.dart`'s launch-time resync primes this state
  from the persisted setting before re-registering reminders.
- The manifest's `SCHEDULE_EXACT_ALARM` `<uses-permission>` stays declared but unused
  unless the setting is on.
