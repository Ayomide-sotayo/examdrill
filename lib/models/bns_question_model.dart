enum BnsCardState { normal, correct, wrong, correction }

const kSlotLabels = [
  'Best Next Step',
  'Not Yet',
  'Later Move',
  'Wrong Choice',
  'Bad Choice',
];

class BnsQuestion {
  final String scenario;

  /// Exactly 5 options, in correct slot order.
  /// options[0] → Best Next Step, options[4] → Bad Choice.
  final List<String> options;

  final String? explanation;

  const BnsQuestion({
    required this.scenario,
    required this.options,
    this.explanation,
  });
}

class BnsQuestionResult {
  final BnsQuestion question;
  final List<int> slotAssignment;
  final List<BnsCardState> finalStates;
  final bool isPerfect;

  BnsQuestionResult({
    required this.question,
    required this.slotAssignment,
    required this.finalStates,
    required this.isPerfect,
  });
}