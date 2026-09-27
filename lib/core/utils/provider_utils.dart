import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Extension methods for safely reading/watching providers without throwing
/// [ProviderNotFoundException] if the provider is not present in the widget tree.
extension SafeProviderContext on BuildContext {
  /// Safely watches [T] from the provider tree, returning null if not found.
  T? watchOrNull<T>() {
    try {
      return Provider.of<T>(this, listen: true);
    } on ProviderNotFoundException {
      return null;
    }
  }

  /// Safely reads [T] from the provider tree, returning null if not found.
  T? readOrNull<T>() {
    try {
      return Provider.of<T>(this, listen: false);
    } on ProviderNotFoundException {
      return null;
    }
  }
}
