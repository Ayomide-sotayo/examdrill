enum QuestionType { text, table, caseStudy, imageGraph }

enum SpanType { plain, correct, wrong }

class ExplanationSpan {
  final String text;
  final SpanType type;

  const ExplanationSpan(this.text, [this.type = SpanType.plain]);
}

class PracticeDrillQuestion {
  final QuestionType type;
  final String question;
  final List<String> options;
  final int correctIndex;
  final List<ExplanationSpan> explanation;
  final String? imagePath;
  final String? caseText;
  final List<List<String>>? tableData;

  PracticeDrillQuestion({
    required this.type,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.imagePath,
    this.caseText,
    this.tableData,
  });
}