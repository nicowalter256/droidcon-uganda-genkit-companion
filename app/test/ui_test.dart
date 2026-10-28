import 'package:droidcon_companion/main.dart';
import 'package:droidcon_companion/schemas.dart';
import 'package:droidcon_companion/session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('welcome screen shows suggestions', (tester) async {
    await tester.pumpWidget(const CompanionApp());

    expect(find.text('Ask me about the schedule'), findsOneWidget);
    expect(find.text('Any Flutter talks on day 2?'), findsOneWidget);
  });

  testWidgets('session card shows time, speaker, room and tags', (
    tester,
  ) async {
    final session = Session(
      id: 'd2-test',
      title: 'Effective App Architecture & State Management in Flutter',
      speaker: 'Bashir Kasujja',
      day: 2,
      startTime: '10:00',
      endTime: '11:00',
      room: 'Visual Spaces',
      tags: ['flutter', 'architecture'],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SessionCard(session: session)),
      ),
    );

    expect(find.text('DAY 2'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('Bashir Kasujja'), findsOneWidget);
    expect(find.text('Visual Spaces'), findsOneWidget);
    expect(find.text('#flutter'), findsOneWidget);
  });
}
