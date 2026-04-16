class Patient {
  final String name;
  final String imagePath;
  final List<String> prescriptions;
  

  const Patient({
    required this.name,
    required this.imagePath,
    required this.prescriptions,  
  });
}

class PatientQuestion {
  final List<Patient> patients; // always 4
  final String question;
  final int correctPatientIndex; // 0-3, which patient is the correct answer
  final String explanation;
  final String explanation1;
  final String explanation2;

  const PatientQuestion({
    required this.patients,
    required this.question,
    required this.correctPatientIndex,
    required this.explanation,
    required this.explanation1,
    required this.explanation2,
  });
}