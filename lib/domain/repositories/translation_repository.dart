import 'package:grant_horners_system/domain/entities/translations.dart';

abstract class TranslationRepository {
  Future<BibleTranslation> load();
  Future<void> save(BibleTranslation translation);
}
