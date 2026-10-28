import 'dart:io';

import 'package:droidcon_companion_backend/flow.dart';
import 'package:genkit/genkit.dart';
import 'package:genkit/io.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_shelf/genkit_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

/// HTTP server for the Flutter app:
///   dart run bin/server.dart
///
/// Serves companionFlow at POST /companionFlow. Run it from backend/ so
/// the tools can find data/schedule.json.
void main() async {
  final ai = Genkit(plugins: [googleAI()]);
  final companionFlow = defineCompanionFlow(ai);

  // GenkitRouter routes each action by its name: /companionFlow.
  final genkit = GenkitRouter()..addAction(companionFlow);
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(genkit.asShelfHandler());

  // anyIPv4 (not localhost) so a real phone on the same Wi-Fi can connect.
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 3400);
  print(
    'Serving companionFlow at http://localhost:${server.port}/companionFlow',
  );
}
