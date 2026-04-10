import '../models/question_model.dart';

final List<QuestionModel> quizQuestions = [
  QuestionModel(
    type: QuestionType.imageGraph,
    question: 'Based on the graph, what is the approximate half-life of Drug-X?',
    options: ['0.5 hour', '1 hour', '2 hours', '4 hours', '5 hours'],
    correctIndex: 2,
    imagePath: 'assets/images/graph_1.svg',
  ),
  QuestionModel(
    type: QuestionType.table,
    question: 'Which extravascular route has the highest absolute bioavailability?',
    options: ['IV', 'SC', 'IM', 'PO', 'ZP'],
    correctIndex: 0,
    tableData: [
      ['Route', 'Dose (mg)', 'AUC (mcg.h/mL)'],
      ['SC', '10', '160'],
      ['IM', '25', '375'],
      ['IV', '5', '100'],
      ['PO', '20', '300'],
    ],
  ),
  QuestionModel(
    type: QuestionType.caseStudy,
    caseText: "Profile shows:\n- Ramipril 10 mg daily\n- Spironolactone 25 mg daily\n- Potassium chloride 20 mEq daily",
    question: 'Best action?',
    options: [
      'Dispense as written',
      'Adjust dose or interval and contact prescriber',
      'Switch to extended-release without prescriber input',
      'Recommend grapefruit juice',
      'Recommend orange juice',
    ],
    correctIndex: 1,
  ),
  QuestionModel(
    type: QuestionType.caseStudy,
    caseText: "Profile shows:\n- Ramipril 10 mg daily\n- Spironolactone 25 mg daily\n- Potassium chloride 20 mEq daily",
    question: 'Which of the following is correct?',
    options: [
      'Volume of distribution',
      'Volume of glucose',
      'Half-life',
      'Serum calcium',
      'Protein binding',
    ],
    correctIndex: 2,
  ),
  QuestionModel(
    type: QuestionType.text,
    question: 'A profile shows “penicillin allergy,” but the patient cannot describe the reaction. A prescription for amoxicillin is presented. What is the best next step?',
    options: [
      'Drug stays in bloodstream',
      'Drug is widely distributed in tissues',
      'Dispense and advise to stop if rash occurs',
      'Drug has low protein binding',
      'Drug has low binding',
    ],
    correctIndex: 1,
  ),
];
