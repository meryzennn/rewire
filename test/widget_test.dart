import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/app.dart';

void main() {
  testWidgets('light theme button label meets WCAG AA contrast', (
    tester,
  ) async {
    await tester.pumpWidget(const RewireApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final style = app.theme!.elevatedButtonTheme.style!;
    final foreground = style.foregroundColor!.resolve({})!;
    final background = style.backgroundColor!.resolve({})!;

    expect(_contrastRatio(foreground, background), greaterThanOrEqualTo(4.5));
  });

  testWidgets('root renders Rewire', (tester) async {
    await tester.pumpWidget(const RewireApp());

    expect(find.text('Rewire'), findsOneWidget);
  });
}

double _contrastRatio(Color foreground, Color background) {
  final lighter = foreground.computeLuminance() > background.computeLuminance()
      ? foreground.computeLuminance()
      : background.computeLuminance();
  final darker = foreground.computeLuminance() > background.computeLuminance()
      ? background.computeLuminance()
      : foreground.computeLuminance();
  return (lighter + 0.05) / (darker + 0.05);
}
