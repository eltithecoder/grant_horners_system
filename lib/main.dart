import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grant_horners_system/domain/entities/translations.dart';
import 'package:grant_horners_system/domain/translation_service.dart';
import 'package:grant_horners_system/firebase_options.dart';
import 'package:grant_horners_system/presentation/reading_list_overview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final service = TranslationService();
  final initial = await service.load();

  translationNotifier = ValueNotifier<BibleTranslation>(initial);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp(translationService: service));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.translationService});

  final TranslationService translationService;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BibleTranslation>(
      valueListenable: translationNotifier,
      builder: (context, translation, _) {
        return MaterialApp(
          title: 'Bible Track',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: ReadingOverviewPage(translationService: translationService),
        );
      },
    );
  }
}
