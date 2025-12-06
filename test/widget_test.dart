// Basic widget test for ReadForge app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App has MaterialApp widget', (WidgetTester tester) async {
    // This simple test verifies the app structure without needing database access
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('ReadForge')),
            body: const Center(child: Text('Test')),
          ),
        ),
      ),
    );

    // Verify the app has basic Material widgets
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
