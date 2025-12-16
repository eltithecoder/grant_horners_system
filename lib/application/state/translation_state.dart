import 'package:flutter/foundation.dart';
import 'package:grant_horners_system/domain/entities/app_language.dart';
import 'package:grant_horners_system/domain/entities/translations.dart';

/// Temporary global holder for translation until BLoC is introduced.
late ValueNotifier<BibleTranslation> translationNotifier;
late ValueNotifier<AppLanguage> languageNotifier;
late ValueNotifier<bool> useBiblaAlNotifier;
