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

  testWidgets('onboarding shows its actions only on the final page', (
    tester,
  ) async {
    await tester.pumpWidget(const RewireApp());

    expect(find.text('Welcome to Rewire'), findsOneWidget);
    expect(find.byKey(const Key('welcome-brain')), findsOneWidget);
    expect(find.text('Mulai Sekarang'), findsNothing);
    expect(find.text('Sudah punya data?'), findsNothing);

    await tester.drag(
      find.byKey(const Key('onboarding-pages')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tiga Pilar Rewire'), findsOneWidget);
    expect(find.text('Mulai Sekarang'), findsNothing);

    await tester.drag(
      find.byKey(const Key('onboarding-pages')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Level Up Otakmu'), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('onboarding-pages')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Atur Pengingat Harian'), findsOneWidget);
    expect(find.text('Mulai Sekarang'), findsOneWidget);
    expect(find.text('Sudah punya data?'), findsOneWidget);
  });

  testWidgets('last-page actions show their not-ready messages', (
    tester,
  ) async {
    await tester.pumpWidget(const RewireApp());
    await tester.drag(
      find.byKey(const Key('onboarding-pages')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('onboarding-pages')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('onboarding-pages')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mulai Sekarang'));
    await tester.pump();
    expect(find.text('Onboarding berikutnya belum tersedia.'), findsOneWidget);

    await tester.tap(find.text('Sudah punya data?'));
    await tester.pump();
    expect(find.text('Pemulihan data belum tersedia.'), findsOneWidget);
  });

  testWidgets('swipe keeps each slide whole until the fade transition', (
    tester,
  ) async {
    await tester.pumpWidget(const RewireApp());
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('onboarding-pages'))),
    );
    await gesture.moveBy(const Offset(-250, 0));
    await tester.pump();

    expect(find.text('Welcome to Rewire'), findsOneWidget);
    expect(find.text('Tiga Pilar Rewire'), findsNothing);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('Tiga Pilar Rewire'), findsOneWidget);
    expect(find.text('Welcome to Rewire'), findsNothing);
  });

  testWidgets('onboarding pages can be advanced with the next control', (
    tester,
  ) async {
    await tester.pumpWidget(const RewireApp());

    for (final title in ['Tiga Pilar Rewire', 'Level Up Otakmu']) {
      await tester.tap(find.text('Selanjutnya'));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
    }
  });

  testWidgets('onboarding scales to short screens without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const RewireApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
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
