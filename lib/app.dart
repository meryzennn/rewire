import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

class RewireApp extends StatelessWidget {
  const RewireApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Rewire',
    theme: buildLightTheme(),
    darkTheme: buildDarkTheme(),
    themeMode: ThemeMode.system,
    home: const _RootPlaceholder(),
  );
}

class _RootPlaceholder extends StatelessWidget {
  const _RootPlaceholder();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Rewire')));
}
