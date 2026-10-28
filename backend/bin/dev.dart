import 'package:droidcon_companion_backend/flow.dart';
import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';

/// Entry point for the Developer UI:
///   genkit start -- dart run bin/dev.dart
///
/// `genkit start` sets GENKIT_ENV=dev, so Genkit starts its reflection
/// server and the Developer UI can list, run and trace companionFlow.
void main() {
  final ai = Genkit(plugins: [googleAI()]);
  defineCompanionFlow(ai);
}
