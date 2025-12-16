// presentation/reading_overview_page.dart

import 'package:flutter/material.dart';
import 'package:grant_horners_system/core/l10n/app_localizations.dart';
import 'package:grant_horners_system/core/l10n/l10n_extensions.dart';
import 'package:grant_horners_system/domain/entities/reading_daily_state.dart';
import 'package:grant_horners_system/domain/entities/reading_list.dart';
import 'package:grant_horners_system/domain/repositories/reading_progress_repository.dart';
import 'package:grant_horners_system/domain/repositories/settings_repository.dart';
import 'package:grant_horners_system/domain/repositories/translation_repository.dart';
import 'package:grant_horners_system/core/link_helper.dart';
import 'package:grant_horners_system/presentation/reading_progress_setup_page.dart';

class ReadingOverviewPage extends StatefulWidget {
  const ReadingOverviewPage({
    super.key,
    required this.translationRepository,
    required this.settingsRepository,
    required this.progressRepository,
  });

  final TranslationRepository translationRepository;
  final SettingsRepository settingsRepository;
  final ReadingProgressRepository progressRepository;

  @override
  State<ReadingOverviewPage> createState() => _ReadingOverviewPageState();
}

class _ReadingOverviewPageState extends State<ReadingOverviewPage> {
  late final ReadingProgressRepository _progressRepository =
      widget.progressRepository;

  Map<ReadingList, ListDailyState> _state = {};
  bool _loading = true;

  // For testing only:
  // int _debugOffsetDays = 0;

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  Future<void> _loadToday() async {
    final map = await _progressRepository.loadForToday();
    setState(() {
      _state = map;
      _loading = false;
      // _debugOffsetDays = 0;
    });
  }

  // Future<void> _simulateNextDay() async {
  //   setState(() => _loading = true);
  //   _debugOffsetDays += 1;

  //   final fakeDate = DateTime.now().add(Duration(days: _debugOffsetDays));
  //   final map = await _progressRepository.loadForDate(fakeDate);

  //   setState(() {
  //     _state = map;
  //     _loading = false;
  //   });
  // }

  Future<void> _onCheckChanged(ReadingList list, bool? value) async {
    final newValue = value ?? false; // treat null as false

    setState(() => _loading = true);
    final updated = await _progressRepository.setTodayCompleted(list, newValue);
    setState(() {
      _state = updated;
      _loading = false;
    });
  }

  // Future<void> _reset() async {
  //   await _progressRepository.reset();
  //   await _loadToday();
  // }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading && _state.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        // title alignment
        centerTitle: false,
        title: Text(l10n.todaysReadingTitle),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final changed = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => ReadingProgressSetupPage(
                    translationRepository: widget.translationRepository,
                    settingsRepository: widget.settingsRepository,
                    progressRepository: widget.progressRepository,
                  ),
                ),
              );

              // If setup page returned true, reload today's progress
              if (changed == true) {
                await _loadToday();
              }
            },
            child: Text(l10n.settings),
          ),

          // IconButton(
          //   icon: const Icon(Icons.skip_next),
          //   tooltip: 'Simulate next day',
          //   onPressed: _simulateNextDay,
          // ),
          // IconButton(
          //   onPressed: _reset,
          //   icon: const Icon(Icons.refresh),
          //   tooltip: 'Reset all progress',
          // ),
        ],
      ),
      body: ListView.builder(
        itemCount: ReadingList.values.length,
        itemBuilder: (context, index) {
          final list = ReadingList.values[index];
          final dailyState = _state[list]!;
          final chapter = dailyState.currentChapter;

          return ListTile(
            title: Text(list.localizedTitle(l10n)),
            subtitle: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () =>
                    openYouVersionForChapter(chapter.book, chapter.chapter),
                child: Text(
                  l10n.chapterLabel(
                    chapter.book.localizedTitle(l10n),
                    chapter.chapter,
                  ),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            trailing: Checkbox(
              value: dailyState.completed,
              onChanged: (val) => _onCheckChanged(list, val),
            ),
          );
        },
      ),
    );
  }
}
