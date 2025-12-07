import 'package:flutter/foundation.dart';

enum BibleTranslation {
  kjv(1, 'KJV'),
  niv(111, 'NIV'),
  esv(59, 'ESV'),
  al(3631, 'AL'),
  albb(7, 'ALBB');

  final int versionId;
  final String label;
  const BibleTranslation(this.versionId, this.label);
}

late ValueNotifier<BibleTranslation> translationNotifier;