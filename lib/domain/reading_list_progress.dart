import 'package:grant_horners_system/domain/entities/book.dart';
import 'package:grant_horners_system/domain/entities/reading_list.dart';


class ChapterRef {
  final Book book;
  final int chapter;

  const ChapterRef({required this.book, required this.chapter});
}

/// Next chapter within a single ReadingList (across its books).
/// If `last` is null → first chapter of the list.
/// If we’re at the end of the last book → returns null (or wrap around if you want).
ChapterRef? nextChapterInList(
  ReadingList list,
  ChapterRef? last,
) {
  final books = list.books;

  // Start of list
  if (last == null) {
    return ChapterRef(book: books.first, chapter: 1);
  }

  final currentBook = last.book;
  final currentChapter = last.chapter;

  final bookIndex = books.indexOf(currentBook);
  if (bookIndex == -1) {
    // Safety: if last.book isn't in this list, just start from the beginning
    return ChapterRef(book: books.first, chapter: 1);
  }

  final maxChapter = currentBook.chapterCount;

  // Next chapter in same book
  if (currentChapter < maxChapter) {
    return ChapterRef(book: currentBook, chapter: currentChapter + 1);
  }

  // Move to next book in this list
  final isLastBook = bookIndex == books.length - 1;
  if (!isLastBook) {
    final nextBook = books[bookIndex + 1];
    return ChapterRef(book: nextBook, chapter: 1);
  }

  // We finished the whole list.
  // Option A: stop here
  return null;

  // Option B (Horner-style): wrap to beginning
  // return ChapterRef(book: books.first, chapter: 1);
}

class ReadingListProgress {
  final Map<ReadingList, ChapterRef?> lastReadByList;

  const ReadingListProgress({required this.lastReadByList});

  factory ReadingListProgress.empty() => ReadingListProgress(
        lastReadByList: {
          for (final list in ReadingList.values) list: null,
        },
      );

  ChapterRef? lastFor(ReadingList list) => lastReadByList[list];

  ChapterRef? nextFor(ReadingList list) {
    return nextChapterInList(list, lastReadByList[list]);
  }

  ReadingListProgress copyWithLast(ReadingList list, ChapterRef? chapter) {
    final newMap = Map<ReadingList, ChapterRef?>.from(lastReadByList);
    newMap[list] = chapter;
    return ReadingListProgress(lastReadByList: newMap);
  }
}