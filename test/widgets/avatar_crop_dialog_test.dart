import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/l10n/app_localizations.dart';
import 'package:rewire/widgets/avatar_crop_dialog.dart';

Future<Uint8List> _createTestPngBytes({int width = 100, int height = 100}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
    recorder,
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
  );
  final paint = Paint()..color = const Color(0xFF4CAF50);
  canvas.drawRect(
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    paint,
  );
  final picture = recorder.endRecording();
  final img = await picture.toImage(width, height);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

void main() {
  late Directory tempDir;
  late File testFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('rewire_test_crop_');
    final bytes = await _createTestPngBytes();
    testFile = File('${tempDir.path}/sample.png');
    await testFile.writeAsBytes(bytes);
  });

  testWidgets('renders AvatarCropDialog with interactive controls and cancels', (
    tester,
  ) async {
    File? cropResult = testFile;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                cropResult = await showDialog<File?>(
                  context: context,
                  builder: (_) => AvatarCropDialog(imageFile: testFile),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();

    // Verify dialog content
    expect(find.byKey(const Key('avatar-crop-dialog')), findsOneWidget);
    expect(find.byKey(const Key('crop-interactive-viewer')), findsOneWidget);
    expect(find.byKey(const Key('btn-cancel-crop')), findsOneWidget);
    expect(find.byKey(const Key('btn-save-crop')), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);

    // Tap cancel
    await tester.tap(find.byKey(const Key('btn-cancel-crop')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('avatar-crop-dialog')), findsNothing);
    expect(cropResult, isNull);
  });

  testWidgets('zoom in and zoom out buttons adjust scale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AvatarCropDialog(imageFile: testFile),
        ),
      ),
    );
    await tester.pump();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();

    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);
    final initialSlider = tester.widget<Slider>(sliderFinder);
    expect(initialSlider.value, 1.0);

    // Tap zoom in
    await tester.tap(find.byIcon(Icons.zoom_in_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final zoomedSlider = tester.widget<Slider>(sliderFinder);
    expect(zoomedSlider.value, greaterThan(1.0));

    // Tap reset
    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final resetSlider = tester.widget<Slider>(sliderFinder);
    expect(resetSlider.value, 1.0);
  });

  testWidgets('tapping save returns cropped file and closes dialog', (
    tester,
  ) async {
    File? cropResult;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                cropResult = await showDialog<File?>(
                  context: context,
                  builder: (_) => AvatarCropDialog(
                    imageFile: testFile,
                    outputDirectory: tempDir,
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();

    expect(find.byKey(const Key('btn-save-crop')), findsOneWidget);

    await tester.tap(find.byKey(const Key('btn-save-crop')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(cropResult, isNotNull);
    expect(cropResult!.existsSync(), isTrue);
  });
}
