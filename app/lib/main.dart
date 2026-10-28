import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genkit/client.dart';
import 'package:http/http.dart' as http;

import 'companion_client.dart';
import 'schemas.dart';
import 'session_card.dart';

void main() => runApp(const CompanionApp());

class CompanionApp extends StatelessWidget {
  const CompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'droidcon Companion',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: const CompanionPage(),
    );
  }
}

ThemeData _theme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1B7F5B),
    brightness: brightness,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

const _suggestions = [
  'Any Flutter talks on day 2?',
  "What's in the Auditorium on day 1?",
  'Who is speaking about Kotlin Multiplatform?',
  'When is the keynote?',
  'Which talks cover on-device AI?',
];

class CompanionPage extends StatefulWidget {
  const CompanionPage({super.key});

  @override
  State<CompanionPage> createState() => _CompanionPageState();
}

class _CompanionPageState extends State<CompanionPage> {
  final _question = TextEditingController();

  bool _loading = false;
  String? _asked;
  _Failure? _failure;
  CompanionOutput? _answer;

  Future<void> _ask([String? preset]) async {
    final question = (preset ?? _question.text).trim();
    if (question.isEmpty || _loading) return;

    FocusScope.of(context).unfocus();
    _question.clear();
    setState(() {
      _loading = true;
      _asked = question;
      _failure = null;
      _answer = null;
    });

    try {
      final answer = await companionFlow(
        input: CompanionInput(question: question),
      ).timeout(const Duration(seconds: 30));
      setState(() => _answer = answer);
    } catch (e) {
      setState(() => _failure = _Failure.from(e));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _reset() => setState(() {
    _asked = null;
    _failure = null;
    _answer = null;
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            _Header(onReset: _asked == null || _loading ? null : _reset),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildBody(),
              ),
            ),
            _InputBar(controller: _question, loading: _loading, onSend: _ask),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return _LoadingView(key: const ValueKey('loading'), question: _asked!);
    }
    if (_failure case final failure?) {
      return _FailureView(
        key: const ValueKey('failure'),
        failure: failure,
        onRetry: () => _ask(_asked),
      );
    }
    if (_answer case final answer?) {
      return _AnswerView(
        key: ValueKey(answer),
        question: _asked!,
        answer: answer,
      );
    }
    return _WelcomeView(key: const ValueKey('welcome'), onAsk: _ask);
  }

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }
}

class _Failure {
  const _Failure(this.icon, this.title, this.message);

  final IconData icon;
  final String title;
  final String message;

  factory _Failure.from(Object e) {
    // The HTTP request itself failed: server not running, wrong URL, ...
    if (e is GenkitException && e.cause is http.ClientException) {
      return const _Failure(
        Icons.cloud_off_rounded,
        "Can't reach the companion server",
        'Is it running at $backendUrl?',
      );
    }
    if (e is TimeoutException) {
      return const _Failure(
        Icons.hourglass_bottom_rounded,
        'That took too long',
        'The server took more than 30 seconds to answer.',
      );
    }
    return const _Failure(
      Icons.error_outline_rounded,
      'Something went wrong',
      "The companion couldn't answer that one.",
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.onReset});

  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final onHeader = scheme.onPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 12,
        8,
        20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            Color.lerp(scheme.primary, scheme.tertiary, 0.7)!,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'droidcon Uganda 2026',
                  style: text.headlineSmall?.copyWith(
                    color: onHeader,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.event_rounded,
                      size: 16,
                      color: onHeader.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'October 28–29 · Schedule companion',
                      style: text.bodyMedium?.copyWith(
                        color: onHeader.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onReset != null)
            IconButton(
              tooltip: 'New question',
              onPressed: onReset,
              icon: Icon(Icons.home_rounded, color: onHeader),
            ),
        ],
      ),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView({super.key, required this.onAsk});

  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      children: [
        // Align stops the ListView stretching the badge to full width.
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 32,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Ask me about the schedule',
          style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'I know every talk, speaker and room across both days.',
          style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        Text(
          'TRY ASKING',
          style: text.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        for (final suggestion in _suggestions)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SuggestionTile(
              label: suggestion,
              onTap: () => onAsk(suggestion),
            ),
          ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.chat_bubble_outline_rounded, color: scheme.primary),
        title: Text(label),
        trailing: Icon(
          Icons.arrow_forward_rounded,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key, required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: [
        _QuestionBubble(question: question),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(width: 12),
            Text(
              'Searching the schedule…',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < 3; i++) ...[
          const _SkeletonCard(),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final block = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget bar(double width) => Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: block,
        borderRadius: BorderRadius.circular(6),
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 104,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 84, color: block),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bar(double.infinity),
                    const SizedBox(height: 10),
                    bar(160),
                    const Spacer(),
                    bar(90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({super.key, required this.failure, required this.onRetry});

  final _Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                failure.icon,
                size: 36,
                color: scheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              failure.title,
              textAlign: TextAlign.center,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              failure.message,
              textAlign: TextAlign.center,
              style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerView extends StatelessWidget {
  const _AnswerView({super.key, required this.question, required this.answer});

  final String question;
  final CompanionOutput answer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final count = answer.sessions.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: [
        _QuestionBubble(question: question),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primaryContainer,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(answer.reply, style: text.bodyLarge),
              ),
            ),
          ],
        ),
        if (count > 0) ...[
          const SizedBox(height: 24),
          Text(
            count == 1 ? '1 SESSION' : '$count SESSIONS',
            style: text.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          for (final session in answer.sessions) ...[
            SessionCard(session: session),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _QuestionBubble extends StatelessWidget {
  const _QuestionBubble({required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            question,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: scheme.onPrimary),
          ),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.loading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool loading;
  final ValueChanged<String?> onSend;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !loading,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(null),
                decoration: const InputDecoration(
                  hintText: 'Ask about talks, speakers, rooms…',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: 'Ask',
              iconSize: 24,
              padding: const EdgeInsets.all(12),
              onPressed: loading ? null : () => onSend(null),
              icon: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Icon(Icons.arrow_upward_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
