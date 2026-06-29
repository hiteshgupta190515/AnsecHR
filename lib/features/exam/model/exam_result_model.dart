class ExamResultModel {
  ExamResultModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.totalMark,
    required this.passMark,
    required this.obtainedMark,
    required this.submitted,
  });
  late final int id;
  late final String startTime;
  late final String endTime;
  late final int totalMark;
  late final int passMark;
  late final int obtainedMark;
  late final bool submitted;

  ExamResultModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    startTime = json['start_time'] ?? '';
    endTime = json['end_time'] ?? '';
    totalMark = int.tryParse(json['total_mark'].toString()) ?? 0;
    passMark = int.tryParse(json['pass_mark'].toString()) ?? 0;
    obtainedMark = int.tryParse(json['obtained_mark'].toString()) ?? 0;
    submitted = json['submitted'] == true;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['total_mark'] = totalMark;
    data['pass_mark'] = passMark;
    data['obtained_mark'] = obtainedMark;
    data['submitted'] = submitted;
    return data;
  }
}
