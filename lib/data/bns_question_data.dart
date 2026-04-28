import 'package:examdril/models/bns_question_model.dart';

const List<BnsQuestion> bnsQuestions = [
  BnsQuestion(
    scenario:
        'A patient with "penicillin allergy" cannot describe the reaction. A prescription for amoxicillin is presented. Arrange the management steps.',
    options: [
      'Clarify allergy history before dispensing',
      'Substitute with azithromycin',
      'Dispense and advise to stop if rash occurs',
      'Dispense with antihistamine pre-treatment',
      'Refuse and end the encounter',
    ],
    explanation:
        'Clarifying the history is essential to determine if it was a true allergy or just a side effect, preventing unnecessary avoidance of first-line therapy.',
  ),
  BnsQuestion(
    scenario:
        'A 62-year-old male has sudden crushing chest pain radiating to his left arm. ECG shows ST elevation. Prioritize management steps.',
    options: [
      'Administer aspirin 300 mg immediately',
      'Obtain IV access and draw cardiac enzymes',
      'Arrange urgent PCI or thrombolysis',
      'Start long-term statin therapy',
      'Discharge with lifestyle advice only',
    ],
    explanation:
        'Aspirin is the most immediate life-saving step. PCI is the definitive goal. Statins are for long-term prevention, and discharge is unsafe for an active MI.',
  ),
  BnsQuestion(
    scenario:
        'A 45-year-old with type 2 diabetes has fasting glucose of 14 mmol/L and HbA1c of 10% on metformin. Prioritise next steps.',
    options: [
      'Review medication adherence and diet',
      'Add a second oral agent (e.g. SGLT2i)',
      'Consider initiating insulin therapy',
      'Order routine complication screening',
      'Continue current metformin dose unchanged',
    ],
    explanation:
        'Verify adherence before escalating. High HbA1c requires a second agent or insulin, but routine screening is not an acute management priority.',
  ),
  BnsQuestion(
    scenario:
        'A mother brings her 8-month-old who has had fever for 3 days, irritability, and a bulging fontanelle. Arrange the management priorities.',
    options: [
      'Perform urgent lumbar puncture and send CSF',
      'Administer IV ceftriaxone immediately',
      'Obtain blood cultures before antibiotics if possible',
      'Arrange CT head if signs of raised ICP',
      'Discharge with oral antibiotics and safety netting',
    ],
    explanation:
        'In suspected meningitis, lumbar puncture/CSF is the priority for diagnosis, followed immediately by broad-spectrum antibiotics. Blood cultures are needed but shouldn\'t delay treatment. CT is only if focal signs exist.',
  ),
  BnsQuestion(
    scenario:
        'A pharmacist receives a warfarin 10 mg prescription for a new AF patient with no prior INR. Arrange the safety steps.',
    options: [
      'Verify the high dose with the prescriber',
      'Counsel patient on interactions and monitoring',
      'Arrange INR monitoring schedule',
      'Dispense with a standard information leaflet',
      'Dispense immediately without intervention',
    ],
    explanation:
        '10mg is a high starting dose with significant bleed risk; verifying intent is crucial. Counseling and monitoring are vital secondary safety steps.',
  ),
];
