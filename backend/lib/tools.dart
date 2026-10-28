import 'dart:convert';
import 'dart:io';

import 'package:genkit/genkit.dart';

import 'schemas.dart';

/// Reads the schedule fresh on each call, so edits to the JSON show up
/// without restarting the server.
Future<List<Session>> loadSchedule() async {
  final json = jsonDecode(await File('data/schedule.json').readAsString());
  return [for (final item in json as List) Session.fromJson(item)];
}

Tool<SearchSessionsInput, List<Session>> defineSearchSessions(Genkit ai) {
  return ai.defineTool(
    name: 'searchSessions',
    description:
        'Searches the droidcon Uganda 2026 schedule. All filters are '
        'optional; call with no filters to get the whole schedule. '
        'Day 1 is October 28 and day 2 is October 29. Breaks such as '
        'lunch are not listed.',
    inputSchema: SearchSessionsInput.$schema,
    outputSchema: .list(Session.$schema),
    fn: (input, _) async {
      final topic = input.topic?.toLowerCase();
      final speaker = input.speaker?.toLowerCase();

      final matches = (await loadSchedule()).where((s) {
        if (input.day != null && s.day != input.day) return false;
        if (topic != null &&
            !s.tags.contains(topic) &&
            !s.title.toLowerCase().contains(topic)) {
          return false;
        }
        if (speaker != null && !s.speaker.toLowerCase().contains(speaker)) {
          return false;
        }
        return true;
      });

      // Leave out abstracts to keep the model's context small.
      return .response([for (final s in matches) s..abstract = null]);
    },
  );
}

Tool<SessionIdInput, Session?> defineGetSessionDetails(Genkit ai) {
  return ai.defineTool(
    name: 'getSessionDetails',
    description: 'Gets one session, including its full abstract, by id.',
    inputSchema: SessionIdInput.$schema,
    outputSchema: .nullable(Session.$schema),
    fn: (input, _) async {
      final schedule = await loadSchedule();
      return .response(schedule.where((s) => s.id == input.id).firstOrNull);
    },
  );
}
