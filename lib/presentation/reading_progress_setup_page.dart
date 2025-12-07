import 'package:flutter/material.dart';
import 'package:grant_horners_system/data/local_reading_progress_data_source.dart';

import '../domain/entities/reading_list.dart';
import '../domain/entities/reading_daily_state.dart'
    show ListDailyState, nextChapterInList, previousChapterInList;

class ReadingProgressSetupPage extends StatefulWidget {
  const ReadingProgressSetupPage({super.key});

  @override
  State<ReadingProgressSetupPage> createState() =>
      _ReadingProgressSetupPageState();
}

class _ReadingProgressSetupPageState extends State<ReadingProgressSetupPage> {
  final _local = LocalReadingProgressDataSource();

  Map<ReadingList, ListDailyState> _state = {};
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    final map = await _local.loadForToday();
    setState(() {
      _state = map;
      _loading = false;
    });
  }

  Future<void> _increment(ReadingList list) async {
    final current = _state[list]!;
    final currentChapter = current.currentChapter;
    final next = nextChapterInList(list, currentChapter);

    if (next == null) {
      // Already at last chapter of this list; do nothing.
      return;
    }

    setState(() {
      _state = {
        ..._state,
        list: current.copyWith(currentChapter: next, completed: false),
      };
    });
  }

  Future<void> _decrement(ReadingList list) async {
    final current = _state[list]!;
    final currentChapter = current.currentChapter;
    final previous = previousChapterInList(list, currentChapter);

    if (previous == null) {
      // Already at first chapter; do nothing.
      return;
    }

    setState(() {
      _state = {
        ..._state,
        list: current.copyWith(currentChapter: previous, completed: false),
      };
    });
  }

  Future<void> _saveAll() async {
    setState(() => _saving = true);

    Map<ReadingList, ListDailyState> latest = _state;
    for (final list in ReadingList.values) {
      final chapter = _state[list]!.currentChapter;
      latest = await _local.setCurrentChapterForToday(list, chapter);
    }

    setState(() {
      _state = latest;
      _saving = false;
    });

    if (!mounted) return;

    // Instead of just showing a snackbar and staying here forever,
    // pop back and signal that something changed:
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Starting Progress'),
        // actions: [
        // IconButton(
        //   onPressed: _reset,
        //   icon: const Icon(Icons.refresh),
        //   tooltip: 'Reset all progress',
        // ),
        // ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Use + and – to set where you are now in each list.\n'
              'This will be the chapter you see today.',
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: ReadingList.values.length,
              itemBuilder: (context, index) {
                final list = ReadingList.values[index];
                final dailyState = _state[list]!;
                final chapter = dailyState.currentChapter;

                return ListTile(
                  title: Text(list.title),
                  subtitle: Text('${chapter.book.title} ${chapter.chapter}'),
                  leading: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _decrement(list),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _increment(list),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _saveAll,
                  icon: _saving
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(_saving ? 'Saving...' : 'Save & Back'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
