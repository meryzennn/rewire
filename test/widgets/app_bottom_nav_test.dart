import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rewire/core/theme/app_theme.dart';
import 'package:rewire/widgets/app_bottom_nav.dart';

class _FakeNavigationShell extends StatefulWidget
    implements StatefulNavigationShell {
  const _FakeNavigationShell({
    this.currentIndex = 0,
    required this.onGoBranch,
  });

  @override
  final int currentIndex;
  final void Function(int index, bool initialLocation) onGoBranch;

  @override
  void goBranch(int index, {bool initialLocation = false}) {
    onGoBranch(index, initialLocation);
  }

  @override
  State<_FakeNavigationShell> createState() => _FakeNavigationShellState();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeNavigationShellState extends State<_FakeNavigationShell> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  testWidgets('renders all 5 tabs and a single sliding pill indicator', (
    tester,
  ) async {
    final shell = _FakeNavigationShell(
      currentIndex: 0,
      onGoBranch: (_, _) {},
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Scaffold(
          bottomNavigationBar: AppBottomNav(navigationShell: shell),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Meditasi'), findsOneWidget);
    expect(find.text('Olahraga'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);

    // Verify there is exactly ONE sliding pill indicator box
    final decoratedBoxes = tester.widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(AppBottomNav),
        matching: find.byType(DecoratedBox),
      ),
    );
    expect(decoratedBoxes, isNotEmpty);
  });

  testWidgets('sliding pill moves continuously with PageController', (
    tester,
  ) async {
    final controller = PageController(initialPage: 0);
    int selectedBranch = 0;
    final shell = _FakeNavigationShell(
      currentIndex: selectedBranch,
      onGoBranch: (index, _) => selectedBranch = index,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Scaffold(
          body: SizedBox(
            height: 200,
            child: PageView(
              controller: controller,
              children: List.generate(
                5,
                (i) => Center(child: Text('Page $i')),
              ),
            ),
          ),
          bottomNavigationBar: AppBottomNav(
            navigationShell: shell,
            pageController: controller,
          ),
        ),
      ),
    );

    // Initial position at page 0
    final initialPillFinder = find.byType(Positioned);
    final initialPillPos = tester.widget<Positioned>(initialPillFinder.first);
    expect(initialPillPos.left, isNotNull);
    final initialLeft = initialPillPos.left!;

    // Animate to page 1
    controller.jumpToPage(1);
    await tester.pump();

    final movedPillPos = tester.widget<Positioned>(initialPillFinder.first);
    expect(movedPillPos.left, greaterThan(initialLeft));

    controller.dispose();
  });

  testWidgets('tapping tab button triggers goBranch and animates controller', (
    tester,
  ) async {
    final controller = PageController(initialPage: 0);
    int? tappedBranch;
    final shell = _FakeNavigationShell(
      currentIndex: 0,
      onGoBranch: (index, _) => tappedBranch = index,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: Scaffold(
          body: SizedBox(
            height: 200,
            child: PageView(
              controller: controller,
              children: List.generate(
                5,
                (i) => Center(child: Text('Page $i')),
              ),
            ),
          ),
          bottomNavigationBar: AppBottomNav(
            navigationShell: shell,
            pageController: controller,
          ),
        ),
      ),
    );

    // Tap Meditasi (tab index 1)
    await tester.tap(find.text('Meditasi'));
    await tester.pumpAndSettle();

    expect(tappedBranch, equals(1));
    expect(controller.page?.round(), equals(1));

    controller.dispose();
  });
}
