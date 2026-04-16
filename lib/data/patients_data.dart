import '../models/patient_model.dart';

// The 4 patients used across all questions
const Patient charles = Patient(
  name: 'Charles',
  imagePath: 'assets/images/charles.png',
  prescriptions: [
    'Ramipril 10mg daily',
    'Spironolactone 25mg daily',
    'Potassium chloride 20 mEq daily',
  ],
);

const Patient sam = Patient(
  name: 'Sam',
  imagePath: 'assets/images/sam.png',
  prescriptions: [
    'Ramipril 10mg daily',
    'Spironolactone 25mg daily',
    'Potassium chloride 10 mEq daily',
  ],
);

const Patient william = Patient(
  name: 'William',
  imagePath: 'assets/images/william.png',
  prescriptions: [
    'Ramipril 10mg daily',
    'Spironolactone 25mg daily',
    'Potassium chloride 15 mEq daily',
  ],
);

const Patient zack = Patient(
  name: 'Zack',
  imagePath: 'assets/images/zack.png',
  prescriptions: [
    'Ramipril 10mg daily',
    'Spironolactone 25mg daily',
    'Amoxillicin 20 mEq daily',
  ],
);

// Questions — same 4 patients, different question each round
final List<PatientQuestion> patientQuestions = [
  PatientQuestion(
    patients: [charles, sam, william, zack],
    question: 'Which of these patients has an increased risk of Hyperkalemia?',
    correctPatientIndex: 0, // Charles
    explanation: 'Charles is taking Ramipril and Potassium chloride, a combination that significantly increases potassium levels in the blood, raising the risk of Hyperkalemia.',
    explanation1: 'Charles is taking Ramipril and Potassium chloride, a combination that significantly increases potassium levels in the blood, raising the risk of Hyperkalemia.',
    explanation2: 'Charles is taking Ramipril and Potassium chloride, a combination that significantly increases potassium levels in the blood, raising the risk of Hyperkalemia.',
  ),
  PatientQuestion(
    patients: [charles, sam, william, zack],
    question: 'Which patient is prescribed an antibiotic?',
    correctPatientIndex: 3, // Zack
   explanation:
        'Zack is the only patient prescribed Amoxicillin, which is a penicillin-type antibiotic used to treat bacterial infections. None of the other patients have an antibiotic in their prescription.',
        explanation1:
        'Zack is the only patient prescribed Amoxicillin, which is a penicillin-type antibiotic used to treat bacterial infections. None of the other patients have an antibiotic in their prescription.',
        explanation2:
        'Zack is the only patient prescribed Amoxicillin, which is a penicillin-type antibiotic used to treat bacterial infections. None of the other patients have an antibiotic in their prescription.',
        
  ),
  PatientQuestion(
    patients: [charles, sam, william, zack],
    question: 'Which patient has the highest Potassium chloride dose?',
    correctPatientIndex: 0, // Charles
     explanation:
        'Charles is prescribed Potassium chloride at 20 mEq daily, which is the highest dose among all four patients. William takes 15 mEq and Sam takes 10 mEq daily.',
        explanation1:
        'Charles is prescribed Potassium chloride at 20 mEq daily, which is the highest dose among all four patients. William takes 15 mEq and Sam takes 10 mEq daily.',
        explanation2:
        'Charles is prescribed Potassium chloride at 20 mEq daily, which is the highest dose among all four patients. William takes 15 mEq and Sam takes 10 mEq daily.',
  ),
];