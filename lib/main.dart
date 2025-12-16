import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grant_horners_system/application/state/translation_state.dart';
import 'package:grant_horners_system/core/l10n/app_localizations.dart';
import 'package:grant_horners_system/data/datasources/local_reading_progress_data_source.dart';
import 'package:grant_horners_system/data/repositories/local_reading_progress_repository.dart';
import 'package:grant_horners_system/data/repositories/shared_prefs_settings_repository.dart';
import 'package:grant_horners_system/data/repositories/shared_prefs_translation_repository.dart';
import 'package:grant_horners_system/domain/entities/app_language.dart';
import 'package:grant_horners_system/domain/entities/translations.dart';
import 'package:grant_horners_system/domain/repositories/reading_progress_repository.dart';
import 'package:grant_horners_system/domain/repositories/settings_repository.dart';
import 'package:grant_horners_system/domain/repositories/translation_repository.dart';
import 'package:grant_horners_system/firebase_options.dart';
import 'package:grant_horners_system/presentation/reading_list_overview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final translationRepository = SharedPrefsTranslationRepository();
  final settingsRepository = SharedPrefsSettingsRepository();
  final progressRepository = LocalReadingProgressRepository(
    LocalReadingProgressDataSource(),
  );

  final initial = await translationRepository.load();
  final initialLanguage = await settingsRepository.loadLanguage();
  final initialUseBiblaAl = await settingsRepository.loadUseBiblaAl();

  translationNotifier = ValueNotifier<BibleTranslation>(initial);
  languageNotifier = ValueNotifier<AppLanguage>(initialLanguage);
  useBiblaAlNotifier = ValueNotifier<bool>(initialUseBiblaAl);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MyApp(
      translationRepository: translationRepository,
      settingsRepository: settingsRepository,
      progressRepository: progressRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.translationRepository,
    required this.settingsRepository,
    required this.progressRepository,
  });

  final TranslationRepository translationRepository;
  final SettingsRepository settingsRepository;
  final ReadingProgressRepository progressRepository;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: languageNotifier,
      builder: (context, language, _) {
        return ValueListenableBuilder<BibleTranslation>(
          valueListenable: translationNotifier,
          builder: (context, _, __) {
            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(language.localeCode),
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: ThemeMode.system,
              home: ReadingOverviewPage(
                translationRepository: translationRepository,
                settingsRepository: settingsRepository,
                progressRepository: progressRepository,
              ),
            );
          },
        );
      },
    );
  }
}
