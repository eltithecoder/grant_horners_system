import 'package:grant_horners_system/domain/entities/book.dart';

/// OSIS codes mapped to your Book enum (modify names if your enum uses different identifiers)
const Map<Book, String> youVersionOsis = {
  Book.genesis: 'GEN',
  Book.exodus: 'EXO',
  Book.leviticus: 'LEV',
  Book.numbers: 'NUM',
  Book.deuteronomy: 'DEU',

  Book.joshua: 'JOS',
  Book.judges: 'JDG',
  Book.ruth: 'RUT',
  Book.firstSamuel: '1SA',
  Book.secondSamuel: '2SA',
  Book.firstKings: '1KI',
  Book.secondKings: '2KI',
  Book.firstChronicles: '1CH',
  Book.secondChronicles: '2CH',
  Book.ezra: 'EZR',
  Book.nehemiah: 'NEH',
  Book.esther: 'EST',

  Book.job: 'JOB',
  Book.psalms: 'PSA',
  Book.proverbs: 'PRO',
  Book.ecclesiastes: 'ECC',
  Book.songOfSongs: 'SNG',

  Book.isaiah: 'ISA',
  Book.jeremiah: 'JER',
  Book.lamentations: 'LAM',
  Book.ezekiel: 'EZK',
  Book.daniel: 'DAN',
  Book.hosea: 'HOS',
  Book.joel: 'JOL',
  Book.amos: 'AMO',
  Book.obadiah: 'OBA',
  Book.jonah: 'JON',
  Book.micah: 'MIC',
  Book.nahum: 'NAM',
  Book.habakkuk: 'HAB',
  Book.zephaniah: 'ZEP',
  Book.haggai: 'HAG',
  Book.zechariah: 'ZEC',
  Book.malachi: 'MAL',

  Book.matthew: 'MAT',
  Book.mark: 'MRK',
  Book.luke: 'LUK',
  Book.john: 'JHN',
  Book.acts: 'ACT',

  Book.romans: 'ROM',
  Book.firstCorinthians: '1CO',
  Book.secondCorinthians: '2CO',
  Book.galatians: 'GAL',
  Book.ephesians: 'EPH',
  Book.philippians: 'PHP',
  Book.colossians: 'COL',
  Book.firstThessalonians: '1TH',
  Book.secondThessalonians: '2TH',
  Book.firstTimothy: '1TI',
  Book.secondTimothy: '2TI',
  Book.titus: 'TIT',
  Book.philemon: 'PHM',
  Book.hebrews: 'HEB',
  Book.james: 'JAS',
  Book.firstPeter: '1PE',
  Book.secondPeter: '2PE',
  Book.firstJohn: '1JN',
  Book.secondJohn: '2JN',
  Book.thirdJohn: '3JN',
  Book.jude: 'JUD',
  Book.revelation: 'REV',
};

String youVersionReference(Book book, int chapter) {
  final osis = youVersionOsis[book]!;
  // Always use verse 1 (YouVersion jumps to the chapter automatically)
  return '$osis.$chapter';
}
