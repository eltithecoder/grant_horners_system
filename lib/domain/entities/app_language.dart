enum AppLanguage {
  english(label: 'English', localeCode: 'en'),
  shqip(label: 'Shqip', localeCode: 'sq');

  final String label;
  final String localeCode;

  const AppLanguage({required this.label, required this.localeCode});
}
