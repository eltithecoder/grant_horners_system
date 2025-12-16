// data/datasources/local_reading_progress_data_source.dart

import 'dart:convert';

import 'package:grant_horners_system/domain/entities/reading_daily_state.dart';
import 'package:grant_horners_system/domain/entities/reading_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalReadingProgressDataSource {
  static const _storageKey = 'reading_daily_progress_v1';

  Future<Map<ReadingList, ListDailyState>> loadForToday() {
    return loadForDate(DateTime.now());
  }

  /// Returns the full map of daily states, normalized for *today*.
  Future<Map<ReadingList, ListDailyState>> loadForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    final today = _dateString(date);

    Map<ReadingList, ListDailyState> result;

    if (raw == null) {
      // First time
      result = {
        for (final list in ReadingList.values)
          list: _initialStateForList(list, today),
      };
    } else {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      result = _fromJson(json);

      // Normalize to the *given* date instead of real today
      result = {
        for (final list in ReadingList.values)
          list: _normalizeForToday(list, result[list], today),
      };
    }

    await _save(result);
    return result;
  }

  Future<Map<ReadingList, ListDailyState>> setCurrentChapterForToday(
    ReadingList list,
    ChapterRef chapter,
  ) async {
    // Normalize everything to *today* first, so we don't accidentally
    // keep an old date.
    final map = await loadForToday();

    final today = _dateString(DateTime.now());
    final updatedForList = ListDailyState(
      currentChapter: chapter,
      currentDate: today,
      completed: false, // after manual change we consider it unread for today
    );

    final updatedMap = Map<ReadingList, ListDailyState>.from(map)
      ..[list] = updatedForList;

    await _save(updatedMap);
    return updatedMap;
  }

  /// Mark today's chapter for [list] as completed.
  /// Does NOT advance chapter; that will happen on the next day.
  Future<Map<ReadingList, ListDailyState>> setTodayCompleted(
    ReadingList list,
    bool completed,
  ) async {
    final current = await loadForToday(); // ensures we are in today's context
    final state = current[list]!;

    // No change needed
    if (state.completed == completed) {
      return current;
    }

    final updatedForList = state.copyWith(completed: completed);
    final updatedMap = Map<ReadingList, ListDailyState>.from(current)
      ..[list] = updatedForList;

    await _save(updatedMap);
    return updatedMap;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  // ---------- Internal helpers ----------

  String _todayString() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _dateString(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  ListDailyState _initialStateForList(ReadingList list, String today) {
    final firstChapter = nextChapterInList(list, null)!;
    return ListDailyState(
      currentChapter: firstChapter,
      currentDate: today,
      completed: false,
    );
  }

  /// Normalize a single list's state to *today*:
  /// - If no state: create initial.
  /// - If date == today: leave as-is.
  /// - If date < today:
  ///   - If completed true → advance to next chapter (if any).
  ///   - If completed false → keep same chapter.
  ListDailyState _normalizeForToday(
    ReadingList list,
    ListDailyState? previous,
    String today,
  ) {
    if (previous == null) {
      return _initialStateForList(list, today);
    }

    if (previous.currentDate == today) {
      return previous;
    }

    if (previous.completed) {
      // Always advance, and thanks to wrapping, this includes
      // last chapter → back to first chapter of first book.
      final next = nextChapterInList(list, previous.currentChapter)!;
      return ListDailyState(
        currentChapter: next,
        currentDate: today,
        completed: false,
      );
    } else {
      // Not completed yesterday → same chapter today.
      return previous.copyWith(currentDate: today, completed: false);
    }
  }

  Future<void> _save(Map<ReadingList, ListDailyState> map) async {
    final prefs = await SharedPreferences.getInstance();
    final json = _toJson(map);
    await prefs.setString(_storageKey, jsonEncode(json));
  }

  Map<String, dynamic> _toJson(Map<ReadingList, ListDailyState> map) {
    return {
      'lists': {
        for (final entry in map.entries) entry.key.name: entry.value.toJson(),
      },
    };
  }

  Map<ReadingList, ListDailyState> _fromJson(Map<String, dynamic> json) {
    final listsJson =
        (json['lists'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    final Map<ReadingList, ListDailyState> result = {};

    for (final list in ReadingList.values) {
      final key = list.name; // "list1", "list2", ...
      final value = listsJson[key];
      if (value == null) {
        result[list] = _initialStateForList(list, _todayString());
      } else {
        result[list] = ListDailyState.fromJson(
          (value as Map).cast<String, dynamic>(),
        );
      }
    }

    return result;
  }
}
