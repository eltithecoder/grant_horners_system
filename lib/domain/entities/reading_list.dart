import 'package:grant_horners_system/domain/entities/book.dart';

enum ReadingList {
  list1(
    'Gospels',
    [
      Book.matthew,
      Book.mark,
      Book.luke,
      Book.john,
    ],
  ),
  list2(
    'Pentateuch',
    [
      Book.genesis,
      Book.exodus,
      Book.leviticus,
      Book.numbers,
      Book.deuteronomy,
    ],
  ),
  list3(
    'Pauline Epistles (Major)',
    [
      Book.romans,
      Book.firstCorinthians,
      Book.secondCorinthians,
      Book.galatians,
      Book.ephesians,
      Book.philippians,
      Book.colossians,
      Book.hebrews,
    ],
  ),
  list4(
    'Pauline Epistles (Minor) & General Epistles',
    [
      Book.firstThessalonians,
      Book.secondThessalonians,
      Book.firstTimothy,
      Book.secondTimothy,
      Book.titus,
      Book.philemon,
      Book.james,
      Book.firstPeter,
      Book.secondPeter,
      Book.firstJohn,
      Book.secondJohn,
      Book.thirdJohn,
      Book.jude,
      Book.revelation,
    ],
  ),
  list5(
    'Wisdom Literature',
    [
      Book.job,
      Book.ecclesiastes,
      Book.songOfSongs,
    ],
  ),
  list6(
    'Psalms',
    [
      Book.psalms,
    ],
  ),
  list7(
    'Proverbs',
    [
      Book.proverbs,
    ],
  ),
  list8(
    'History of Israel',
    [
      Book.joshua,
      Book.judges,
      Book.ruth,
      Book.firstSamuel,
      Book.secondSamuel,
      Book.firstKings,
      Book.secondKings,
      Book.firstChronicles,
      Book.secondChronicles,
      Book.ezra,
      Book.nehemiah,
      Book.esther,
    ],
  ),
  list9(
    'Major & Minor Prophets',
    [
      Book.isaiah,
      Book.jeremiah,
      Book.lamentations,
      Book.ezekiel,
      Book.daniel,
      Book.hosea,
      Book.joel,
      Book.amos,
      Book.obadiah,
      Book.jonah,
      Book.micah,
      Book.nahum,
      Book.habakkuk,
      Book.zephaniah,
      Book.haggai,
      Book.zechariah,
      Book.malachi,
    ],
  ),
  list10(
    'Acts',
    [
      Book.acts,
    ],
  );

  const ReadingList(
    this.title,
    this.books,
  );

  final String title;
  final List<Book> books;
}