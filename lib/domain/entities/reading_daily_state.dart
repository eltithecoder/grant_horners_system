// domain/entities/reading_daily_state.dart

import 'book.dart';
import 'reading_list.dart';

/// One specific chapter in a book.
class ChapterRef {
  final Book book;
  final int chapter;

  const ChapterRef({required this.book, required this.chapter});

  Map<String, dynamic> toJson() => {
    'book': book.name, // enum name
    'chapter': chapter,
  };

  factory ChapterRef.fromJson(Map<String, dynamic> json) {
    final bookName = json['book'] as String;
    final chapter = json['chapter'] as int;

    final book = Book.values.firstWhere(
      (b) => b.name == bookName,
      orElse: () => Book.values.first,
    );

    return ChapterRef(book: book, chapter: chapter);
  }
}

/// Daily state for ONE ReadingList.
/// - [currentChapter]: chapter assigned for the *currentDate*.
/// - [currentDate]: yyyy-MM-dd string (the day this state is for).
/// - [completed]: whether it was checked (read) on currentDate.
class ListDailyState {
  final ChapterRef currentChapter;
  final String currentDate; // 'yyyy-MM-dd'
  final bool completed;

  const ListDailyState({
    required this.currentChapter,
    required this.currentDate,
    required this.completed,
  });

  ListDailyState copyWith({
    ChapterRef? currentChapter,
    String? currentDate,
    bool? completed,
  }) {
    return ListDailyState(
      currentChapter: currentChapter ?? this.currentChapter,
      currentDate: currentDate ?? this.currentDate,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentChapter': currentChapter.toJson(),
    'currentDate': currentDate,
    'completed': completed,
  };

  factory ListDailyState.fromJson(Map<String, dynamic> json) {
    return ListDailyState(
      currentChapter: ChapterRef.fromJson(
        (json['currentChapter'] as Map).cast<String, dynamic>(),
      ),
      currentDate: json['currentDate'] as String,
      completed: json['completed'] as bool? ?? false,
    );
  }
}

ChapterRef? nextChapterInList(ReadingList list, ChapterRef? lastChapter) {
  final books = list.books;

  // First ever chapter for this list
  if (lastChapter == null) {
    final firstBook = books.first;
    return ChapterRef(book: firstBook, chapter: 1);
  }

  final currentBook = lastChapter.book;
  final currentChapter = lastChapter.chapter;

  final bookIndex = books.indexOf(currentBook);
  if (bookIndex == -1) {
    // Safety: if it's not in the list for some reason, restart
    final firstBook = books.first;
    return ChapterRef(book: firstBook, chapter: 1);
  }

  final maxChapter = currentBook.chapterCount;

  // Next chapter in the same book
  if (currentChapter < maxChapter) {
    return ChapterRef(book: currentBook, chapter: currentChapter + 1);
  }

  // Move to next book in the list
  final isLastBook = bookIndex == books.length - 1;
  if (!isLastBook) {
    final nextBook = books[bookIndex + 1];
    return ChapterRef(book: nextBook, chapter: 1);
  }

  // NEW: loop back to the beginning of the list
  final firstBook = books.first;
  return ChapterRef(book: firstBook, chapter: 1);
}

ChapterRef firstChapterInList(ReadingList list) {
  return nextChapterInList(list, null)!;
}

/// Walks from the beginning of the list until it finds the chapter right
/// before [current]. Returns null if [current] is the first chapter.
ChapterRef? previousChapterInList(ReadingList list, ChapterRef current) {
  ChapterRef? previous;
  ChapterRef? cursor = nextChapterInList(list, null); // first chapter

  while (cursor != null) {
    if (cursor.book == current.book && cursor.chapter == current.chapter) {
      return previous; // we just reached current; previous is the one before it
    }
    previous = cursor;
    cursor = nextChapterInList(list, cursor);
  }

  return null; // current not found (shouldn't happen in normal use)
}
