import 'package:flutter/material.dart';
import 'package:grant_horners_system/application/state/translation_state.dart';
import 'package:grant_horners_system/core/l10n/app_localizations.dart';
import 'package:grant_horners_system/core/l10n/l10n_extensions.dart';
import 'package:grant_horners_system/domain/entities/app_language.dart';
import 'package:grant_horners_system/domain/entities/reading_daily_state.dart'
    show ListDailyState, nextChapterInList, previousChapterInList;
import 'package:grant_horners_system/domain/entities/reading_list.dart';
import 'package:grant_horners_system/domain/entities/translations.dart';
import 'package:grant_horners_system/domain/repositories/reading_progress_repository.dart';
import 'package:grant_horners_system/domain/repositories/settings_repository.dart';
import 'package:grant_horners_system/domain/repositories/translation_repository.dart';

class ReadingProgressSetupPage extends StatefulWidget {
  const ReadingProgressSetupPage({
    super.key,
    required this.translationRepository,
    required this.settingsRepository,
    required this.progressRepository,
  });

  final TranslationRepository translationRepository;
  final SettingsRepository settingsRepository;
  final ReadingProgressRepository progressRepository;

  @override
  State<ReadingProgressSetupPage> createState() =>
      _ReadingProgressSetupPageState();
}

class _ReadingProgressSetupPageState extends State<ReadingProgressSetupPage> {
  late final ReadingProgressRepository _progressRepository =
      widget.progressRepository;
  late final SettingsRepository _settingsRepository =
      widget.settingsRepository;

  TranslationRepository get translationRepository =>
      widget.translationRepository;

  Map<ReadingList, ListDailyState> _state = {};
  bool _loading = true;
  bool _saving = false;
  AppLanguage _language = languageNotifier.value;
  bool _useBiblaAl = useBiblaAlNotifier.value;

  @override
  void initState() {
    super.initState();
    _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    final map = await _progressRepository.loadForToday();
    setState(() {
      _state = map;
      _loading = false;
    });
  }

  Future<void> _onTranslationChanged(BibleTranslation? translation) async {
    if (translation == null) return;
    translationNotifier.value = translation;
    await translationRepository.save(translation);
  }

  Future<void> _onLanguageChanged(AppLanguage? language) async {
    if (language == null) return;
    setState(() => _language = language);
    languageNotifier.value = language;
    await _settingsRepository.saveLanguage(language);
  }

  Future<void> _onUseBiblaAlChanged(bool value) async {
    setState(() => _useBiblaAl = value);
    useBiblaAlNotifier.value = value;
    await _settingsRepository.saveUseBiblaAl(value);
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
      latest = await _progressRepository.setCurrentChapterForToday(
        list,
        chapter,
      );
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
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          Text(
            l10n.settingsIntro,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(l10n.readingPositionsTitle),
                  subtitle: Text(l10n.readingPositionsSubtitle),
                ),
                const Divider(height: 1),
                ...ListTile.divideTiles(
                  context: context,
                  tiles: ReadingList.values.map((list) {
                    final dailyState = _state[list]!;
                    final chapter = dailyState.currentChapter;

                    return ListTile(
                      title: Text(list.localizedTitle(l10n)),
                      subtitle: Text(
                        l10n.chapterLabel(
                          chapter.book.localizedTitle(l10n),
                          chapter.chapter,
                        ),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _decrement(list),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _increment(list),
                      ),
                    );
                  }),
                ).toList(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.languageTitle),
                  subtitle: Text(l10n.languageSubtitle),
                  trailing: DropdownButton<AppLanguage>(
                    value: _language,
                    onChanged: _onLanguageChanged,
                    items: AppLanguage.values
                        .map(
                          (lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang.localizedLabel(l10n)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.bibleTranslationTitle),
                  subtitle: Text(l10n.bibleTranslationSubtitle),
                  trailing: DropdownButton<BibleTranslation>(
                    value: translationNotifier.value,
                    onChanged: _onTranslationChanged,
                    items: BibleTranslation.values
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.label),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SwitchListTile(
                  title: Text(l10n.useBiblaTitle),
                  subtitle: Text(l10n.useBiblaSubtitle),
                  value: _useBiblaAl,
                  onChanged: _onUseBiblaAlChanged,
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
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
                  label: Text(_saving ? l10n.savingLabel : l10n.saveAndBack),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
