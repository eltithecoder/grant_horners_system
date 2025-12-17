// presentation/reading_overview_page.dart

import 'package:flutter/material.dart';
import 'package:grant_horners_system/application/state/translation_state.dart';
import 'package:grant_horners_system/core/l10n/app_localizations.dart';
import 'package:grant_horners_system/core/l10n/l10n_extensions.dart';
import 'package:grant_horners_system/domain/entities/book.dart';
import 'package:grant_horners_system/domain/entities/reading_daily_state.dart';
import 'package:grant_horners_system/domain/entities/reading_list.dart';
import 'package:grant_horners_system/domain/repositories/reading_progress_repository.dart';
import 'package:grant_horners_system/domain/repositories/settings_repository.dart';
import 'package:grant_horners_system/domain/repositories/translation_repository.dart';
import 'package:grant_horners_system/core/link_helper.dart';
import 'package:grant_horners_system/presentation/reading_progress_setup_page.dart';
import 'package:just_audio/just_audio.dart';
import 'package:grant_horners_system/domain/entities/translations.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();

  Map<ReadingList, ListDailyState> _state = {};
  bool _loading = true;
  ReadingList? _expandedList;
  final Map<String, Duration?> _audioDurations = {};
  final Set<String> _audioLoading = {};
  final Set<String> _audioFailed = {};

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
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _audioKey(Book book, int chapter) => '${book.name}-$chapter';

  Future<void> _loadAudioDuration(String key, Uri url) async {
    if (_audioLoading.contains(key)) return;
    _audioLoading.add(key);
    try {
      final duration = await _audioPlayer.setUrl(url.toString());
      setState(() {
        _audioDurations[key] = duration;
        _audioFailed.remove(key);
      });
    } catch (_) {
      setState(() {
        _audioDurations[key] = null;
        _audioFailed.add(key);
      });
    } finally {
      _audioLoading.remove(key);
    }
  }

  String _formatDuration(Duration duration, AppLocalizations l10n) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return l10n.audioDuration(minutes, seconds);
  }

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
          final isExpanded = _expandedList == list;
          final chapterLabel = l10n.chapterLabel(
            chapter.book.localizedTitle(l10n),
            chapter.chapter,
          );
          final useBiblaAudio = useBiblaAlNotifier.value &&
              (translationNotifier.value == BibleTranslation.al ||
                  translationNotifier.value == BibleTranslation.albb);
          final audioUri = useBiblaAudio
              ? biblaAudioUri(
                  chapter.book,
                  chapter.chapter,
                )
              : null;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _expandedList = isExpanded ? null : list;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text(list.localizedTitle(l10n)),
                      subtitle: Text(chapterLabel),
                      trailing: Checkbox(
                        value: dailyState.completed,
                        onChanged: (val) => _onCheckChanged(list, val),
                      ),
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.chapterProgress(
                                chapter.chapter,
                                chapter.book.chapterCount,
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => openYouVersionForChapter(
                                    chapter.book,
                                    chapter.chapter,
                                  ),
                                  icon: const Icon(Icons.menu_book_outlined),
                                  label: Text(l10n.readChapter),
                                ),
                                const SizedBox(width: 8),
                                if (useBiblaAudio) ...[
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: () => launchUrl(
                                      audioUri!,
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    icon: const Icon(Icons.headset),
                                    label: Text(l10n.listenChapter),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
