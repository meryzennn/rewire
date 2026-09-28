import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// Extension for fast, clean access to AppLocalizations in any BuildContext.
extension AppLocalizationsX on BuildContext {
  /// Shorthand to access localized strings: `context.l10n.someString`.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
