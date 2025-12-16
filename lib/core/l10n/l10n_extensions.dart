import 'package:grant_horners_system/core/l10n/app_localizations.dart';
import 'package:grant_horners_system/domain/entities/app_language.dart';
// import 'package:grant_horners_system/domain/entities/app_language.dart';
import 'package:grant_horners_system/domain/entities/book.dart';
import 'package:grant_horners_system/domain/entities/reading_list.dart';

extension BookLocalization on Book {
  String localizedTitle(AppLocalizations l10n) {
    switch (this) {
      case Book.genesis:
        return l10n.bookGenesis;
      case Book.exodus:
        return l10n.bookExodus;
      case Book.leviticus:
        return l10n.bookLeviticus;
      case Book.numbers:
        return l10n.bookNumbers;
      case Book.deuteronomy:
        return l10n.bookDeuteronomy;
      case Book.joshua:
        return l10n.bookJoshua;
      case Book.judges:
        return l10n.bookJudges;
      case Book.ruth:
        return l10n.bookRuth;
      case Book.firstSamuel:
        return l10n.book1Samuel;
      case Book.secondSamuel:
        return l10n.book2Samuel;
      case Book.firstKings:
        return l10n.book1Kings;
      case Book.secondKings:
        return l10n.book2Kings;
      case Book.firstChronicles:
        return l10n.book1Chronicles;
      case Book.secondChronicles:
        return l10n.book2Chronicles;
      case Book.ezra:
        return l10n.bookEzra;
      case Book.nehemiah:
        return l10n.bookNehemiah;
      case Book.esther:
        return l10n.bookEsther;
      case Book.job:
        return l10n.bookJob;
      case Book.psalms:
        return l10n.bookPsalms;
      case Book.proverbs:
        return l10n.bookProverbs;
      case Book.ecclesiastes:
        return l10n.bookEcclesiastes;
      case Book.songOfSongs:
        return l10n.bookSongOfSongs;
      case Book.isaiah:
        return l10n.bookIsaiah;
      case Book.jeremiah:
        return l10n.bookJeremiah;
      case Book.lamentations:
        return l10n.bookLamentations;
      case Book.ezekiel:
        return l10n.bookEzekiel;
      case Book.daniel:
        return l10n.bookDaniel;
      case Book.hosea:
        return l10n.bookHosea;
      case Book.joel:
        return l10n.bookJoel;
      case Book.amos:
        return l10n.bookAmos;
      case Book.obadiah:
        return l10n.bookObadiah;
      case Book.jonah:
        return l10n.bookJonah;
      case Book.micah:
        return l10n.bookMicah;
      case Book.nahum:
        return l10n.bookNahum;
      case Book.habakkuk:
        return l10n.bookHabakkuk;
      case Book.zephaniah:
        return l10n.bookZephaniah;
      case Book.haggai:
        return l10n.bookHaggai;
      case Book.zechariah:
        return l10n.bookZechariah;
      case Book.malachi:
        return l10n.bookMalachi;
      case Book.matthew:
        return l10n.bookMatthew;
      case Book.mark:
        return l10n.bookMark;
      case Book.luke:
        return l10n.bookLuke;
      case Book.john:
        return l10n.bookJohn;
      case Book.acts:
        return l10n.bookActs;
      case Book.romans:
        return l10n.bookRomans;
      case Book.firstCorinthians:
        return l10n.book1Corinthians;
      case Book.secondCorinthians:
        return l10n.book2Corinthians;
      case Book.galatians:
        return l10n.bookGalatians;
      case Book.ephesians:
        return l10n.bookEphesians;
      case Book.philippians:
        return l10n.bookPhilippians;
      case Book.colossians:
        return l10n.bookColossians;
      case Book.firstThessalonians:
        return l10n.book1Thessalonians;
      case Book.secondThessalonians:
        return l10n.book2Thessalonians;
      case Book.firstTimothy:
        return l10n.book1Timothy;
      case Book.secondTimothy:
        return l10n.book2Timothy;
      case Book.titus:
        return l10n.bookTitus;
      case Book.philemon:
        return l10n.bookPhilemon;
      case Book.hebrews:
        return l10n.bookHebrews;
      case Book.james:
        return l10n.bookJames;
      case Book.firstPeter:
        return l10n.book1Peter;
      case Book.secondPeter:
        return l10n.book2Peter;
      case Book.firstJohn:
        return l10n.book1John;
      case Book.secondJohn:
        return l10n.book2John;
      case Book.thirdJohn:
        return l10n.book3John;
      case Book.jude:
        return l10n.bookJude;
      case Book.revelation:
        return l10n.bookRevelation;
    }
  }
}

extension ReadingListLocalization on ReadingList {
  String localizedTitle(AppLocalizations l10n) {
    switch (this) {
      case ReadingList.list1:
        return l10n.readingListGospels;
      case ReadingList.list2:
        return l10n.readingListPentateuch;
      case ReadingList.list3:
        return l10n.readingListPaulineMajor;
      case ReadingList.list4:
        return l10n.readingListPaulineMinor;
      case ReadingList.list5:
        return l10n.readingListWisdom;
      case ReadingList.list6:
        return l10n.readingListPsalms;
      case ReadingList.list7:
        return l10n.readingListProverbs;
      case ReadingList.list8:
        return l10n.readingListHistory;
      case ReadingList.list9:
        return l10n.readingListProphets;
      case ReadingList.list10:
        return l10n.readingListActs;
    }
  }
}

extension AppLanguageLocalization on AppLanguage {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case AppLanguage.english:
        // Manually localize the language labels since corresponding
        // getters are not generated by AppLocalizations.
        // For English UI we show "English"; for Albanian UI we show
        // the Albanian word for English ("Anglisht").
        if (l10n.localeName.startsWith('sq')) {
          return 'Anglisht';
        }
        return 'English';
      case AppLanguage.shqip:
        // "Shqip" is used in both English and Albanian UIs.
        return 'Shqip';
    }
  }
}
