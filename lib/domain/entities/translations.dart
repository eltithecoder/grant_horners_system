enum BibleTranslation {
  kjv(youVersionId: 1, label: 'KJV'),
  nkjv(youVersionId: 114, label: 'NKJV'),
  csb(youVersionId: 1713, label: 'CSB'),
  niv(youVersionId: 111, label: 'NIV'),
  esv(youVersionId: 59, label: 'ESV'),
  al(youVersionId: 3631, label: 'AL'),
  albb(youVersionId: 7, label: 'ALBB');

  final int youVersionId;
  final String label;

  const BibleTranslation({required this.youVersionId, required this.label});
}
