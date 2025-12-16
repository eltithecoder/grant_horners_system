import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:grant_horners_system/application/state/translation_state.dart';
import 'package:grant_horners_system/core/youversion_osis.dart';
import 'package:grant_horners_system/domain/entities/book.dart';
import 'package:grant_horners_system/domain/entities/translations.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openYouVersionForChapter(Book book, int chapter) async {
  final ref = youVersionReference(book, chapter);
  final translation = translationNotifier.value;

  if (_shouldUseBiblaAl(translation)) {
    final biblaUri = Uri.https('bibla.al', '/', {'q': ref});
    if (await launchUrl(biblaUri, mode: LaunchMode.externalApplication)) {
      return;
    }
  }

  final youVersionUri = Uri.parse('youversion://bible?reference=$ref');
  final webUri = Uri.parse(
    'https://www.bible.com/bible/${translation.youVersionId}/$ref',
  );
  if (!kIsWeb) {
    // Try native deep link first
    if (await canLaunchUrl(youVersionUri)) {
      await launchUrl(youVersionUri, mode: LaunchMode.externalApplication);
      return;
    }
  }

  // Fallback (and used always on web)
  await launchUrl(webUri, mode: LaunchMode.externalApplication);
}

bool _shouldUseBiblaAl(BibleTranslation translation) {
  if (!useBiblaAlNotifier.value) return false;
  return translation == BibleTranslation.al || translation == BibleTranslation.albb;
}
