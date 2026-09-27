import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/widgets/celebration_overlay.dart';
import 'package:rewire/widgets/level_up_dialog.dart';

void main() {
  testWidgets('renders LevelUpDialog components and dismisses on tap', (tester) async {
    var dismissed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(
            level: 6,
            brainStage: 'awakening',
            onDismiss: () => dismissed = true,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('LEVEL UP!'), findsOneWidget);
    expect(find.text('Level 6'), findsOneWidget);
    expect(find.text('STAGE: AWAKENING'), findsOneWidget);
    expect(
      find.text('Jalur saraf baru berhasil terbentuk!\nOtakmu semakin bertumbuh dan berevolusi.'),
      findsOneWidget,
    );
    expect(find.byType(CelebrationOverlay), findsOneWidget);

    await tester.tap(find.text('Lanjutkan Perjalanan 🚀'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(dismissed, isTrue);
  });
}
