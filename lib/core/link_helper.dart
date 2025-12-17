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
    final slug = biblaSlug(book);
    if (slug != null) {
      final biblaUri = Uri.https(_biblaHost(translation), '/$slug-$chapter');
      if (await launchUrl(biblaUri, mode: LaunchMode.externalApplication)) {
        return;
      }
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

String? biblaSlug(Book book) {
  final name = _albanianBookNames[book];
  if (name == null) return null;
  return _slugify(name);
}

Uri? biblaAudioUri(Book book, int chapter) {
  final slug = biblaSlug(book);
  if (slug == null) return null;
  final host = _biblaHost(translationNotifier.value);
  return Uri.https(host, '/audio/$slug/$slug-$chapter.mp3');
}

String _biblaHost(BibleTranslation translation) {
  if (translation == BibleTranslation.albb) return 'albb.bibla.al';
  return 'bibla.al';
}

String _slugify(String input) {
  final normalized = input
      .toLowerCase()
      .replaceAll('ë', 'e')
      .replaceAll('ç', 'c');
  final slug = normalized
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp('-+'), '-')
      .replaceAll(RegExp(r'^-|-?$'), '');
  return slug;
}

const Map<Book, String> _albanianBookNames = {
  Book.genesis: 'Zanafilla',
  Book.exodus: 'Dalja',
  Book.leviticus: 'Levitiku',
  Book.numbers: 'Numrat',
  Book.deuteronomy: 'Ligji i Përtërirë',
  Book.joshua: 'Jozueu',
  Book.judges: 'Gjyqtarët',
  Book.ruth: 'Ruthi',
  Book.firstSamuel: '1 Samueli',
  Book.secondSamuel: '2 Samueli',
  Book.firstKings: '1 Mbretërve',
  Book.secondKings: '2 Mbretërve',
  Book.firstChronicles: '1 Kronikave',
  Book.secondChronicles: '2 Kronikave',
  Book.ezra: 'Ezdra',
  Book.nehemiah: 'Nehemia',
  Book.esther: 'Esteri',
  Book.job: 'Jobi',
  Book.psalms: 'Psalmet',
  Book.proverbs: 'Fjalët e Urta',
  Book.ecclesiastes: 'Predikuesi',
  Book.songOfSongs: 'Kënga e Këngëve',
  Book.isaiah: 'Isaia',
  Book.jeremiah: 'Jeremia',
  Book.lamentations: 'Vajtimet',
  Book.ezekiel: 'Ezekieli',
  Book.daniel: 'Danieli',
  Book.hosea: 'Hosea',
  Book.joel: 'Joeli',
  Book.amos: 'Amosi',
  Book.obadiah: 'Obadia',
  Book.jonah: 'Jona',
  Book.micah: 'Mikea',
  Book.nahum: 'Nahumi',
  Book.habakkuk: 'Habakuku',
  Book.zephaniah: 'Sofonia',
  Book.haggai: 'Hagaiu',
  Book.zechariah: 'Zakaria',
  Book.malachi: 'Malakia',
  Book.matthew: 'Mateu',
  Book.mark: 'Marku',
  Book.luke: 'Luka',
  Book.john: 'Gjoni',
  Book.acts: 'Veprat',
  Book.romans: 'Romakëve',
  Book.firstCorinthians: '1 Korintasve',
  Book.secondCorinthians: '2 Korintasve',
  Book.galatians: 'Galatasve',
  Book.ephesians: 'Efesianëve',
  Book.philippians: 'Filipianëve',
  Book.colossians: 'Kolosasve',
  Book.firstThessalonians: '1 Thesalonikasve',
  Book.secondThessalonians: '2 Thesalonikasve',
  Book.firstTimothy: '1 Timoteut',
  Book.secondTimothy: '2 Timoteut',
  Book.titus: 'Titit',
  Book.philemon: 'Filemonit',
  Book.hebrews: 'Hebrenjve',
  Book.james: 'Jakobi',
  Book.firstPeter: '1 Pjetri',
  Book.secondPeter: '2 Pjetri',
  Book.firstJohn: '1 Gjoni',
  Book.secondJohn: '2 Gjoni',
  Book.thirdJohn: '3 Gjoni',
  Book.jude: 'Juda',
  Book.revelation: 'Zbulesa',
};
