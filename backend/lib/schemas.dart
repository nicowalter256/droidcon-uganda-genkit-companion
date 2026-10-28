import 'package:schemantic/schemantic.dart';

part 'schemas.g.dart';

@Schema(description: 'A session on the droidcon Uganda 2026 schedule.')
abstract class $Session {
  String get id;
  String get title;
  String get speaker;

  @IntegerField(minimum: 1, maximum: 2)
  int get day;

  @Field(description: '24h time, e.g. "09:30"')
  String get startTime;

  @Field(description: '24h time, e.g. "10:15"')
  String get endTime;

  String get room;

  @Field(description: 'Lowercase topics, e.g. "flutter", "compose", "ai"')
  List<String> get tags;

  @Field(description: 'Full description. Only included by getSessionDetails.')
  String? get abstract;
}

@Schema()
abstract class $CompanionInput {
  String get question;
}

@Schema()
abstract class $CompanionOutput {
  @Field(description: 'A short, friendly answer (1-2 sentences).')
  String get reply;

  @Field(description: 'Sessions that answer the question, copied from tool results.')
  List<$Session> get sessions;
}

// Tool inputs

@Schema()
abstract class $SearchSessionsInput {
  @IntegerField(description: 'Conference day: 1 or 2', minimum: 1, maximum: 2)
  int? get day;

  @Field(description: 'A topic or tag, e.g. "flutter", "compose", "ai"')
  String? get topic;

  @Field(description: 'Full or partial speaker name')
  String? get speaker;
}

@Schema()
abstract class $SessionIdInput {
  String get id;
}
