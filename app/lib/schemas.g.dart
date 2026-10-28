// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

base class Session {
  /// Creates a [Session] from a JSON map.
  factory Session.fromJson(Map<String, dynamic> json) => $schema.parse(json);

  Session._(this._json);

  Session({
    required String id,
    required String title,
    required String speaker,
    required int day,
    required String startTime,
    required String endTime,
    required String room,
    required List<String> tags,
    String? abstract,
  }) {
    _json = {
      'id': id,
      'title': title,
      'speaker': speaker,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'tags': tags,
      'abstract': ?abstract,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [Session].
  static const SchemanticType<Session> $schema = _SessionTypeFactory();

  String get id {
    return _json['id'] as String;
  }

  set id(String value) {
    _json['id'] = value;
  }

  String get title {
    return _json['title'] as String;
  }

  set title(String value) {
    _json['title'] = value;
  }

  String get speaker {
    return _json['speaker'] as String;
  }

  set speaker(String value) {
    _json['speaker'] = value;
  }

  int get day {
    return (_json['day'] as num).toInt();
  }

  set day(int value) {
    _json['day'] = value;
  }

  String get startTime {
    return _json['startTime'] as String;
  }

  set startTime(String value) {
    _json['startTime'] = value;
  }

  String get endTime {
    return _json['endTime'] as String;
  }

  set endTime(String value) {
    _json['endTime'] = value;
  }

  String get room {
    return _json['room'] as String;
  }

  set room(String value) {
    _json['room'] = value;
  }

  List<String> get tags {
    return (_json['tags'] as List).cast<String>();
  }

  set tags(List<String> value) {
    _json['tags'] = value;
  }

  String? get abstract {
    return _json['abstract'] as String?;
  }

  set abstract(String? value) {
    if (value == null) {
      _json.remove('abstract');
    } else {
      _json['abstract'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [Session] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _SessionTypeFactory extends SchemanticType<Session> {
  const _SessionTypeFactory();

  @override
  Session parse(Object? json) {
    return Session._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'Session',
    definition: <String, Object?>{
      'type': 'object',
      'description': 'A session on the droidcon Uganda 2026 schedule.',
      'properties': <String, Object?>{
        'id': <String, Object?>{'type': 'string'},
        'title': <String, Object?>{'type': 'string'},
        'speaker': <String, Object?>{'type': 'string'},
        'day': <String, Object?>{'type': 'integer', 'minimum': 1, 'maximum': 2},
        'startTime': <String, Object?>{
          'type': 'string',
          'description': '24h time, e.g. "09:30"',
        },
        'endTime': <String, Object?>{
          'type': 'string',
          'description': '24h time, e.g. "10:15"',
        },
        'room': <String, Object?>{'type': 'string'},
        'tags': <String, Object?>{
          'type': 'array',
          'description': 'Lowercase topics, e.g. "flutter", "compose", "ai"',
          'items': <String, Object?>{'type': 'string'},
        },
        'abstract': <String, Object?>{
          'type': 'string',
          'description':
              'Full description. Only included by getSessionDetails.',
        },
      },
      'required': [
        'id',
        'title',
        'speaker',
        'day',
        'startTime',
        'endTime',
        'room',
        'tags',
      ],
    },
    dependencies: [],
  );
}

base class CompanionInput {
  /// Creates a [CompanionInput] from a JSON map.
  factory CompanionInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CompanionInput._(this._json);

  CompanionInput({required String question}) {
    _json = {'question': question};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CompanionInput].
  static const SchemanticType<CompanionInput> $schema =
      _CompanionInputTypeFactory();

  String get question {
    return _json['question'] as String;
  }

  set question(String value) {
    _json['question'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CompanionInput] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CompanionInputTypeFactory extends SchemanticType<CompanionInput> {
  const _CompanionInputTypeFactory();

  @override
  CompanionInput parse(Object? json) {
    return CompanionInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CompanionInput',
    definition: <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'question': <String, Object?>{'type': 'string'},
      },
      'required': ['question'],
    },
    dependencies: [],
  );
}

base class CompanionOutput {
  /// Creates a [CompanionOutput] from a JSON map.
  factory CompanionOutput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CompanionOutput._(this._json);

  CompanionOutput({required String reply, required List<Session> sessions}) {
    _json = {
      'reply': reply,
      'sessions': sessions.map((e) => e.toJson()).toList(),
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CompanionOutput].
  static const SchemanticType<CompanionOutput> $schema =
      _CompanionOutputTypeFactory();

  String get reply {
    return _json['reply'] as String;
  }

  set reply(String value) {
    _json['reply'] = value;
  }

  List<Session> get sessions {
    return (_json['sessions'] as List)
        .map((e) => Session.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  set sessions(List<Session> value) {
    _json['sessions'] = value.map((e) => e.toJson()).toList();
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CompanionOutput] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CompanionOutputTypeFactory extends SchemanticType<CompanionOutput> {
  const _CompanionOutputTypeFactory();

  @override
  CompanionOutput parse(Object? json) {
    return CompanionOutput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CompanionOutput',
    definition: <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'reply': <String, Object?>{
          'type': 'string',
          'description': 'A short, friendly answer (1-2 sentences).',
        },
        'sessions': <String, Object?>{
          'type': 'array',
          'description':
              'Sessions that answer the question, copied from tool results.',
          'items': <String, Object?>{r'$ref': r'#/$defs/Session'},
        },
      },
      'required': ['reply', 'sessions'],
    },
    dependencies: [Session.$schema],
  );
}

base class SearchSessionsInput {
  /// Creates a [SearchSessionsInput] from a JSON map.
  factory SearchSessionsInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  SearchSessionsInput._(this._json);

  SearchSessionsInput({int? day, String? topic, String? speaker}) {
    _json = {'day': ?day, 'topic': ?topic, 'speaker': ?speaker};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [SearchSessionsInput].
  static const SchemanticType<SearchSessionsInput> $schema =
      _SearchSessionsInputTypeFactory();

  int? get day {
    return (_json['day'] as num?)?.toInt();
  }

  set day(int? value) {
    if (value == null) {
      _json.remove('day');
    } else {
      _json['day'] = value;
    }
  }

  String? get topic {
    return _json['topic'] as String?;
  }

  set topic(String? value) {
    if (value == null) {
      _json.remove('topic');
    } else {
      _json['topic'] = value;
    }
  }

  String? get speaker {
    return _json['speaker'] as String?;
  }

  set speaker(String? value) {
    if (value == null) {
      _json.remove('speaker');
    } else {
      _json['speaker'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [SearchSessionsInput] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _SearchSessionsInputTypeFactory
    extends SchemanticType<SearchSessionsInput> {
  const _SearchSessionsInputTypeFactory();

  @override
  SearchSessionsInput parse(Object? json) {
    return SearchSessionsInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'SearchSessionsInput',
    definition: <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'day': <String, Object?>{
          'type': 'integer',
          'description': 'Conference day: 1 or 2',
          'minimum': 1,
          'maximum': 2,
        },
        'topic': <String, Object?>{
          'type': 'string',
          'description': 'A topic or tag, e.g. "flutter", "compose", "ai"',
        },
        'speaker': <String, Object?>{
          'type': 'string',
          'description': 'Full or partial speaker name',
        },
      },
    },
    dependencies: [],
  );
}

base class SessionIdInput {
  /// Creates a [SessionIdInput] from a JSON map.
  factory SessionIdInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  SessionIdInput._(this._json);

  SessionIdInput({required String id}) {
    _json = {'id': id};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [SessionIdInput].
  static const SchemanticType<SessionIdInput> $schema =
      _SessionIdInputTypeFactory();

  String get id {
    return _json['id'] as String;
  }

  set id(String value) {
    _json['id'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [SessionIdInput] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _SessionIdInputTypeFactory extends SchemanticType<SessionIdInput> {
  const _SessionIdInputTypeFactory();

  @override
  SessionIdInput parse(Object? json) {
    return SessionIdInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'SessionIdInput',
    definition: <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'id': <String, Object?>{'type': 'string'},
      },
      'required': ['id'],
    },
    dependencies: [],
  );
}
