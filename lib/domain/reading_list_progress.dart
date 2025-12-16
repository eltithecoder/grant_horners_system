import 'package:grant_horners_system/domain/entities/reading_daily_state.dart';
import 'package:grant_horners_system/domain/entities/reading_list.dart';

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
