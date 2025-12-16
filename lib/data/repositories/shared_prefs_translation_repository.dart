import 'package:grant_horners_system/domain/entities/translations.dart';
import 'package:grant_horners_system/domain/repositories/translation_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsTranslationRepository implements TranslationRepository {
  static const _key = 'bible_translation_v1';

  @override
  Future<BibleTranslation> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    if (name == null) return BibleTranslation.esv; // default

    return BibleTranslation.values.firstWhere(
      (t) => t.name == name,
      orElse: () => BibleTranslation.esv,
    );
  }

  @override
  Future<void> save(BibleTranslation translation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, translation.name);
  }
}
