import 'package:grant_horners_system/domain/entities/reading_daily_state.dart';
import 'package:grant_horners_system/domain/entities/reading_list.dart';

abstract class ReadingProgressRepository {
  Future<Map<ReadingList, ListDailyState>> loadForDate(DateTime date);

  Future<Map<ReadingList, ListDailyState>> loadForToday();

  Future<Map<ReadingList, ListDailyState>> setTodayCompleted(
    ReadingList list,
    bool completed,
  );

  Future<Map<ReadingList, ListDailyState>> setCurrentChapterForToday(
    ReadingList list,
    ChapterRef chapter,
  );

  Future<void> reset();
}
