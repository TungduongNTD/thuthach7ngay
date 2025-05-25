import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:thuthach7ngay/blocs/theme_cubit.dart';
import 'package:thuthach7ngay/l10n/app_localizations.dart';

import '../blocs/locale_cubit.dart';

final getIt = GetIt.instance;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = getIt.get<AppLocalizations>();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme setting
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.theme,
                    style: themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      return Row(
                        children: [
                          Expanded(
                            child: RadioListTile<ThemeMode>(
                              title: Text(tr.light),
                              value: ThemeMode.light,
                              groupValue: themeMode,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<ThemeCubit>().setTheme(value);
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<ThemeMode>(
                              title: Text(tr.dark),
                              value: ThemeMode.dark,
                              groupValue: themeMode,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<ThemeCubit>().setTheme(value);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Language setting
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.language,
                    style: themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: Localizations.localeOf(context).languageCode,
                    items: [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text(tr.english),
                      ),
                      DropdownMenuItem(
                        value: 'vi',
                        child: Text(tr.vietnamese),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LocaleCubit>().setLocale(Locale(value));
                        // Reload the app
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Data export
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.data_export,
                    style: themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý xuất dữ liệu ở đây
                      _exportData(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(tr.export_data),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context) async {
    // TODO: Triển khai logic xuất dữ liệu
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      // Giả lập quá trình xuất dữ liệu
      await Future.delayed(const Duration(seconds: 1));

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.export_success),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.export_failed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}