import '../models/practice_drill_question_model.dart';

final List<PracticeDrillQuestion> practiceDrillQuestions = [
  PracticeDrillQuestion(
    type: QuestionType.imageGraph,
    question: 'Based on the graph, what is the approximate half-life of Drug-X?',
    options: ['0.5 hour', '1 hour', '2 hours', '4 hours', '5 hours'],
    correctIndex: 1,
    imagePath: 'assets/images/graph_1.svg',
    explanation: [
      ExplanationSpan('1 HOUR', SpanType.correct),
      ExplanationSpan(
        ' is the approximate half-life of Drug-X, when proper observation '
        'of the graph is looked at from point 16mg/L, not ',
      ),
      ExplanationSpan('0.5 HOUR', SpanType.wrong),
    ],
  ),
  PracticeDrillQuestion(
    type: QuestionType.table,
    question: 'Which extravascular route has the highest absolute bioavailability?',
    options: ['IV', 'SC', 'IM', 'PO', 'ALL ARE EQUAL'],
    correctIndex: 0,
    tableData: [
      ['Route', 'Dose (mg)', 'AUC (mcg.h/mL)'],
      ['SC', '10', '160'],
      ['IM', '25', '375'],
      ['IV', '5', '100'],
      ['PO', '20', '300'],
    ],
    explanation: [
      ExplanationSpan('IV', SpanType.correct),
      ExplanationSpan(
        ' is the reference standard with 100% bioavailability by definition. '
        'Absolute bioavailability = AUC_route / AUC_IV × Dose_IV / Dose_route. '
        'SC = 80%, IM = 75%, PO = 75%. The answer is not ',
      ),
      ExplanationSpan('ALL ARE EQUAL', SpanType.wrong),
    ],
  ),
  PracticeDrillQuestion(
    type: QuestionType.caseStudy,
    caseText:
        'Profile shows:\n- Ramipril 10 mg daily\n- Spironolactone 25 mg daily\n- Potassium chloride 20 mEq daily',
    question: 'Best action?',
    options: [
      'Dispense as written',
      'Adjust dose or interval and contact prescriber',
      'Switch to extended-release without prescriber input',
      'Recommend grapefruit juice',
      'Recommend orange juice',
    ],
    correctIndex: 1,
    explanation: [
      ExplanationSpan('ADJUST DOSE OR INTERVAL AND CONTACT PRESCRIBER', SpanType.correct),
      ExplanationSpan(
        ' is the best action. Ramipril and spironolactone both raise potassium, '
        'and adding KCl creates a serious hyperkalemia risk — the prescriber must '
        'be contacted before dispensing, not ',
      ),
      ExplanationSpan('DISPENSE AS WRITTEN', SpanType.wrong),
    ],
  ),
  PracticeDrillQuestion(
    type: QuestionType.caseStudy,
    caseText:
        'Profile shows:\n- Ramipril 10 mg daily\n- Spironolactone 25 mg daily\n- Potassium chloride 20 mEq daily',
    question: 'Which parameter is most at risk of being elevated in this patient?',
    options: [
      'Volume of distribution',
      'Volume of glucose',
      'Serum potassium',
      'Serum calcium',
      'Protein binding',
    ],
    correctIndex: 2,
    explanation: [
      ExplanationSpan('SERUM POTASSIUM', SpanType.correct),
      ExplanationSpan(
        ' is the parameter most at risk. Both ramipril (ACE inhibitor) and '
        'spironolactone (potassium-sparing diuretic) independently raise serum '
        'potassium, and the KCl supplement further compounds the risk, not ',
      ),
      ExplanationSpan('SERUM CALCIUM', SpanType.wrong),
    ],
  ),
  PracticeDrillQuestion(
    type: QuestionType.text,
    question:
        'A profile shows "penicillin allergy," but the patient cannot describe '
        'the reaction. A prescription for amoxicillin is presented. '
        'What is the best next step?',
    options: [
      'Dispense and advise to stop if rash occurs',
      'Refuse and end the encounter',
      'Clarify the allergy reaction with the patient and contact the prescriber',
      'Drug has low protein binding',
      'Drug has low binding',
    ],
    correctIndex: 2,
    explanation: [
      ExplanationSpan('CLARIFY THE ALLERGY AND CONTACT THE PRESCRIBER', SpanType.correct),
      ExplanationSpan(
        ' is the best next step to qualify the reaction so as to go back '
        'and check out the concentration of the penicillin in the amoxicillin, not ',
      ),
      ExplanationSpan('DISPENSE AND ADVISE TO STOP IF RASH OCCURS', SpanType.wrong),
    ],
  ),
];