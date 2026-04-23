import 'package:examdril/models/bns_question_model.dart';

const List<BnsQuestion> bnsQuestions = [
  BnsQuestion(
    scenario:
        'A patient shows "penicillin allergy" but the patient cannot describe the reaction. A prescription for amoxicillin is presented. Place the following cards accordingly.',
    options: [
      'Clarify the allergy history before dispensing',
      'Dispense and advise stop if rash occurs',
      'Dispense with diphenhydramine pre-treatment',
      'Refuse and end the encounter',
      'Automatically substitute azithromycin',
    ],
    explanation:
        'Clarifying the allergy history is the gold standard when a patient cannot describe a reaction. This determines if the "allergy" was actually a side effect (nausea) or a true IgE-mediated response, preventing unnecessary avoidance of first-line therapy.',
  ),
  BnsQuestion(
    scenario:
        'A 62-year-old male presents with sudden onset crushing chest pain radiating to his left arm for 30 minutes. ECG shows ST elevation in leads II, III, and aVF. Arrange the following management steps.',
    options: [
      'Administer aspirin 300 mg immediately',
      'Obtain IV access and draw cardiac enzymes',
      'Arrange urgent PCI or thrombolysis',
      'Start statin therapy for long-term management',
      'Discharge with lifestyle advice only',
    ],
    explanation:
        'Aspirin is the most immediate life-saving intervention. Diagnostic steps like IV access and enzymes follow, while definitive reperfusion (PCI) is the goal. Statins are for secondary prevention, and discharge is inappropriate for an active STEMI.',
  ),
  BnsQuestion(
    scenario:
        'A 45-year-old with type 2 diabetes has a fasting glucose of 14 mmol/L and HbA1c of 10% on metformin alone. Prioritise your next steps.',
    options: [
      'Review medication adherence and diet history',
      'Add a second oral agent (e.g. SGLT2 inhibitor)',
      'Consider initiating insulin therapy',
      'Order diabetic complication screening (eye, renal)',
      'Continue current metformin dose unchanged',
    ],
    explanation:
        'Always verify adherence and lifestyle before escalating therapy. Given the high HbA1c, adding a second agent or considering insulin is necessary, but complication screening is a routine health maintenance task rather than an acute management step.',
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
        'A pharmacist receives a prescription for warfarin 10 mg daily for a newly diagnosed AF patient with no prior INR. Arrange appropriate actions.',
    options: [
      'Contact prescriber to verify the dose is intentional',
      'Counsel the patient on warfarin interactions and monitoring',
      'Arrange INR monitoring schedule with GP',
      'Dispense with a standard patient information leaflet',
      'Dispense immediately without any intervention',
    ],
    explanation:
        '10mg is a high starting dose for warfarin and carries a significant bleed risk; verifying intent is crucial. Proper counseling and monitoring setup are secondary but vital safety steps before the patient starts the medication.',
  ),
];
