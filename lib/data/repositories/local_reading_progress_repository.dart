import 'package:grant_horners_system/data/datasources/local_reading_progress_data_source.dart';
import 'package:grant_horners_system/domain/entities/reading_daily_state.dart';
import 'package:grant_horners_system/domain/entities/reading_list.dart';
import 'package:grant_horners_system/domain/repositories/reading_progress_repository.dart';

class LocalReadingProgressRepository implements ReadingProgressRepository {
  LocalReadingProgressRepository(this._dataSource);

  final LocalReadingProgressDataSource _dataSource;

  @override
  Future<Map<ReadingList, ListDailyState>> loadForDate(DateTime date) {
    return _dataSource.loadForDate(date);
  }

  @override
  Future<Map<ReadingList, ListDailyState>> loadForToday() {
    return _dataSource.loadForToday();
  }

  @override
  Future<Map<ReadingList, ListDailyState>> setCurrentChapterForToday(
    ReadingList list,
    ChapterRef chapter,
  ) {
    return _dataSource.setCurrentChapterForToday(list, chapter);
  }

  @override
  Future<Map<ReadingList, ListDailyState>> setTodayCompleted(
    ReadingList list,
    bool completed,
  ) {
    return _dataSource.setTodayCompleted(list, completed);
  }

  @override
  Future<void> reset() {
    return _dataSource.reset();
  }
}
