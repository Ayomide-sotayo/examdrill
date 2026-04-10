enum QuestionType { text, table, caseStudy, imageGraph }

class QuestionModel {
  final QuestionType type;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? imagePath; // null if no image
  final String? caseText;
  final List<List<String>>? tableData;

  QuestionModel({
    required this.type,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.imagePath,
    this.caseText,
    this.tableData,
  });
}