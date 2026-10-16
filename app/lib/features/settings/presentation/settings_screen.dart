import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../application/settings_providers.dart';

/// Settings tab — language, theme, upgrade, and account controls.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final locale = ref.watch(localeControllerProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(s.settingsLanguage),
          _LocaleTile(
            label: 'ระบบ / System',
            selected: locale == null,
            onTap: () => ref.read(localeControllerProvider.notifier).set(null),
          ),
          _LocaleTile(
            label: 'ไทย',
            selected: locale?.languageCode == 'th',
            onTap: () => ref
                .read(localeControllerProvider.notifier)
                .set(const Locale('th')),
          ),
          _LocaleTile(
            label: 'English',
            selected: locale?.languageCode == 'en',
            onTap: () => ref
                .read(localeControllerProvider.notifier)
                .set(const Locale('en')),
          ),
          _LocaleTile(
            label: '中文',
            selected: locale?.languageCode == 'zh',
            onTap: () => ref
                .read(localeControllerProvider.notifier)
                .set(const Locale('zh')),
          ),
          const Divider(height: 32),
          _SectionHeader(s.settingsTheme),
          // Flutter 3.44 groups radios via a RadioGroup ancestor rather than
          // per-tile groupValue/onChanged.
          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (m) {
              if (m != null) {
                ref.read(themeModeControllerProvider.notifier).set(m);
              }
            },
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(s.settingsThemeSystem),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(s.settingsThemeLight),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(s.settingsThemeDark),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.workspace_premium_rounded),
            title: Text(s.settingsUpgrade),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(s.settingsUpgrade)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline_rounded,
                color: Theme.of(context).colorScheme.error),
            title: Text(
              s.settingsDeleteAccount,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => _confirmDelete(context, s.settingsDeleteAccount),
          ),
        ],
      ),
    );
  }

  // Apple/Google require an in-app account-deletion path. This is the entry
  // point; the actual server-side erasure call is added with auth.
  void _confirmDelete(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text(
            'This permanently deletes your account and data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
              color:
                  Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
      ),
    );
  }
}

class _LocaleTile extends StatelessWidget {
  const _LocaleTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected
          ? Icon(Icons.check_rounded,
              color: Theme.of(context).colorScheme.secondary)
          : null,
      onTap: onTap,
    );
  }
}
