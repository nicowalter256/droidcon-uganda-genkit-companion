import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';

import 'schemas.dart';
import 'tools.dart';

const _systemPrompt = '''
You are the droidcon Uganda 2026 companion (October 28-29, 2026).
Answer questions about the conference schedule.

Rules:
- ONLY answer from tool results. Never invent sessions, speakers, times or rooms.
- Use searchSessions to find sessions; use getSessionDetails when the user
  asks what a talk is about.
- If nothing matches, say so honestly and return an empty sessions list.
- Keep the reply short and friendly: one or two sentences. The app shows
  the sessions as cards, so don't repeat their details in the reply.
''';

Flow<CompanionInput, CompanionOutput, void, void> defineCompanionFlow(
  Genkit ai,
) {
  final searchSessions = defineSearchSessions(ai);
  final getSessionDetails = defineGetSessionDetails(ai);

  return ai.defineFlow(
    name: 'companionFlow',
    inputSchema: CompanionInput.$schema,
    outputSchema: CompanionOutput.$schema,
    fn: (input, _) async {
      final response = await ai.generate(
        model: googleAI.gemini('gemini-3.1-flash-lite'),
        system: _systemPrompt,
        prompt: input.question,
        tools: [searchSessions, getSessionDetails],
        outputSchema: CompanionOutput.$schema,
      );

      // generate() reports model failures (bad API key, safety block, ...)
      // via finishReason rather than throwing, so surface them here.
      final output = response.output;
      if (output == null) {
        throw GenkitException('No answer: ${response.finishMessage}');
      }
      return output;
    },
  );
}
