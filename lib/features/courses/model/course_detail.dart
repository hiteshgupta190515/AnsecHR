import 'dart:convert';

class CourseDetailModel {
  CourseDetailModel({
    required this.course,
    required this.description,
    required this.chapters,
    required this.reviews,
  });
  late final Course course;
  late final List<Description> description;
  late final List<Chapters> chapters;
  late final List<Quiz> quizzes;
  late final List<Exam> exams;
  late final List<Reviews> reviews;

  CourseDetailModel.fromJson(Map<String, dynamic> json) {
    course = Course.fromJson(json['course']);
    description = List.from(json['description'] ?? [])
        .map((e) => Description.fromJson(e))
        .toList();
    chapters = List.from(json['chapters'] ?? [])
        .map((e) => Chapters.fromJson(e))
        .toList();
    quizzes = List.from(json['quizzes'] ?? [])
        .map((e) => Quiz.fromMap(e))
        .toList();
    exams = List.from(json['exams'] ?? [])
        .map((e) => Exam.fromJson(e))
        .toList();
    reviews = List.from(json['reviews'] ?? [])
        .map((e) => Reviews.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['course'] = course.toJson();
    data['description'] = description.map((e) => e.toJson()).toList();
    data['chapters'] = chapters.map((e) => e.toJson()).toList();
    data['quizzes'] = quizzes.map((e) => e.toJson()).toList();
    data['exams'] = exams.map((e) => e.toJson()).toList();
    data['reviews'] = reviews.map((e) => e.toJson()).toList();
    return data;
  }
}

class Course {
  Course({
    required this.id,
    required this.category,
    required this.title,
    required this.thumbnail,
    this.video,
    required this.viewCount,
    required this.regularPrice,
    required this.price,
    required this.instructor,
    required this.publishedAt,
    required this.totalDuration,
    required this.videoCount,
    required this.noteCount,
    required this.audioCount,
    required this.chapterCount,
    required this.studentCount,
    required this.reviewCount,
    required this.averageRating,
    this.submittedReview,
    required this.isFavourite,
    required this.isEnrolled,
    required this.isReviewed,
    required this.canReview,
    required this.isFree,
  });
  late final int id;
  late final String category;
  late final String title;
  late final String thumbnail;
  String? video;
  late final int viewCount;
  var regularPrice;
  var price;
  SubmittedReview? submittedReview;
  late final Instructor instructor;
  late final String publishedAt;
  late final int totalDuration;
  late final int videoCount;
  late final int noteCount;
  late final int audioCount;
  late final int chapterCount;
  late final int studentCount;
  late final int reviewCount;
  var averageRating;
  late final bool isFavourite;
  late final bool isEnrolled;
  late bool isReviewed;
  late final bool canReview;
  late final bool isFree;

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    video = json['video'];
    
    // Defensive parsing for all numeric fields
    viewCount = int.tryParse(json['view_count'].toString()) ?? 0;
    regularPrice = json['regular_price'];
    price = json['price'];
    instructor = Instructor.fromJson(json['instructor']);
    
    if (json['submitted_review'] != null) {
      submittedReview = SubmittedReview.fromJson(json['submitted_review']);
    }
    
    publishedAt = json['published_at'].toString();
    totalDuration = int.tryParse(json['total_duration'].toString()) ?? 0;
    videoCount = int.tryParse(json['video_count'].toString()) ?? 0;
    noteCount = int.tryParse(json['note_count'].toString()) ?? 0;
    audioCount = int.tryParse(json['audio_count'].toString()) ?? 0;
    chapterCount = int.tryParse(json['chapter_count'].toString()) ?? 0;
    studentCount = int.tryParse(json['student_count'].toString()) ?? 0;
    reviewCount = int.tryParse(json['review_count'].toString()) ?? 0;
    averageRating = json['average_rating'];
    
    isFavourite = json['is_favourite'] ?? false;
    isEnrolled = json['is_enrolled'] ?? false;
    isReviewed = json['is_reviewed'] ?? false;
    canReview = json['can_review'] ?? false;
    isFree = json['is_free'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['title'] = title;
    data['thumbnail'] = thumbnail;
    data['video'] = video;
    data['view_count'] = viewCount;
    data['regular_price'] = regularPrice;
    data['price'] = price;
    data['instructor'] = instructor.toJson();
    if (submittedReview != null) {
      data['submitted_review'] = submittedReview!.toJson();
    }
    data['published_at'] = publishedAt;
    data['total_duration'] = totalDuration;
    data['video_count'] = videoCount;
    data['note_count'] = noteCount;
    data['audio_count'] = audioCount;
    data['chapter_count'] = chapterCount;
    data['student_count'] = studentCount;
    data['review_count'] = reviewCount;
    data['average_rating'] = averageRating;
    data['is_favourite'] = isFavourite;
    data['is_enrolled'] = isEnrolled;
    data['is_reviewed'] = isReviewed;
    data['can_review'] = canReview;
    return data;
  }
}

class Instructor {
  Instructor({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.title,
    required this.isFeatured,
  });
  late final int id;
  late final String name;
  late final String profilePicture;
  late final String title;
  late final int isFeatured;

  Instructor.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    name = json['name'] ?? "";
    profilePicture = json['profile_picture'] ?? "";
    title = json['title'] ?? "";
    isFeatured = int.tryParse(json['is_featured'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profile_picture'] = profilePicture;
    data['title'] = title;
    data['is_featured'] = isFeatured;
    return data;
  }
}

class SubmittedReview {
  SubmittedReview({
    required this.rating,
    required this.comment,
  });
  var rating;
  late final String comment;

  SubmittedReview.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    comment = json['comment'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}

class Description {
  Description({
    required this.body,
    required this.heading,
  });

  late final String body;
  late final String heading;

  Description.fromJson(Map<String, dynamic> json) {
    body = json['body'] ?? "";
    heading = json['heading'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['body'] = body;
    data['heading'] = heading;
    return data;
  }
}

class Chapters {
  Chapters({
    required this.title,
    required this.serialNumber,
    required this.totalDuration,
    required this.contents,
  });
  late final String title;
  late final int serialNumber;
  late final int totalDuration;
  late final List<Contents> contents;

  Chapters.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    serialNumber = int.tryParse(json['serial_number'].toString()) ?? 0;
    totalDuration = int.tryParse(json['total_duration'].toString()) ?? 0;
    contents = List.from(json['contents'] ?? [])
        .map((e) => Contents.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['serial_number'] = serialNumber;
    data['total_duration'] = totalDuration;
    data['contents'] = contents.map((e) => e.toJson()).toList();
    return data;
  }
}

class Contents {
  Contents({
    required this.id,
    required this.title,
    required this.type,
    this.duration,
    required this.media,
    required this.mediaLink,
    required this.isForwardable,
    required this.serialNumber,
    required this.fileExtension,
    required this.fileNameWithExtension,
    required this.fileNameWithoutExtension,
    required this.isViewed,
    this.mediaUpdatedAt,
  });
  late final int id;
  late final String title;
  late final String type;
  late final duration;
  late final String media;
  late final String? mediaLink;
  late final int isForwardable;
  late final int serialNumber;
  late final String? fileExtension;
  late final String fileNameWithExtension;
  late final String fileNameWithoutExtension;
  late final bool isViewed;
  late final bool isContentFree;
  String? mediaUpdatedAt;

  Contents.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    title = json['title'] ?? "";
    type = json['type'] ?? "";
    duration = json['duration'];
    media = json['media'] ?? "";
    mediaLink = json['media_link'];
    isForwardable = int.tryParse(json['is_forwardable'].toString()) ?? 0;
    serialNumber = int.tryParse(json['serial_number'].toString()) ?? 0;
    fileExtension = json['file_extension'] as String?;
    fileNameWithExtension = json['file_name_with_extension'] ?? "";
    fileNameWithoutExtension = json['file_name_without_extension'] ?? "";
    isViewed = json['is_viewed'] ?? false;
    mediaUpdatedAt = json['media_updated_at'];
    isContentFree = json['is_free'].toString() == "1" || json['is_free'] == true;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['duration'] = duration;
    data['media'] = media;
    data['media_link'] = mediaLink;
    data['is_forwardable'] = isForwardable;
    data['serial_number'] = serialNumber;
    data['file_extension'] = fileExtension ?? '';
    data['file_name_with_extension'] = fileNameWithExtension;
    data['file_name_without_extension'] = fileNameWithoutExtension;
    data['is_viewed'] = isViewed;
    data['media_updated_at'] = mediaUpdatedAt;
    data['is_free'] = isContentFree;
    return data;
  }
}

class Reviews {
  Reviews({
    required this.user,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
  late final User user;
  late final double rating;
  late final String comment;
  late final String createdAt;

  Reviews.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    rating = double.tryParse(json['rating'].toString()) ?? 0.0;
    comment = json['comment'] ?? "";
    createdAt = json['created_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user'] = user.toJson();
    data['rating'] = rating;
    data['comment'] = comment;
    data['created_at'] = createdAt;
    return data;
  }
}

class User {
  User({
    required this.id,
    required this.phone,
    required this.email,
    required this.name,
    required this.profilePicture,
    required this.isActive,
    required this.isAdmin,
  });
  late final int id;
  late final String phone;
  late final String email;
  late final String name;
  late final String profilePicture;
  late final int isActive;
  late final int isAdmin;

  User.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    phone = json['phone'] ?? "";
    email = json['email'] ?? "";
    name = json['name'] ?? "";
    profilePicture = json['profile_picture'] ?? "";
    isActive = int.tryParse(json['is_active'].toString()) ?? 0;
    isAdmin = int.tryParse(json['is_admin'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['email'] = email;
    data['name'] = name;
    data['profile_picture'] = profilePicture;
    data['is_active'] = isActive;
    data['is_admin'] = isAdmin;
    return data;
  }
}

class Quiz {
  final int id;
  final String title;
  final int durationPerQuestion;
  final int markPerQuestion;
  final int questionsCount;
  Quiz({
    required this.id,
    required this.title,
    required this.durationPerQuestion,
    required this.markPerQuestion,
    required this.questionsCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'duration_per_question': durationPerQuestion,
      'mark_per_question': markPerQuestion,
      'question_count': questionsCount,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: int.tryParse(map['id'].toString()) ?? 0,
      title: map['title'] ?? "",
      durationPerQuestion: int.tryParse(map['duration_per_question'].toString()) ?? 0,
      markPerQuestion: int.tryParse(map['mark_per_question'].toString()) ?? 0,
      questionsCount: int.tryParse(map['question_count'].toString()) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quiz.fromJson(String source) =>
      Quiz.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Exam {
  Exam({
    required this.id,
    required this.title,
    required this.duration,
    required this.markPerQuestion,
    required this.passMarks,
    required this.questionCount,
  });
  late final int id;
  late final String title;
  late final int duration;
  late final int markPerQuestion;
  late final int passMarks;
  late final int questionCount;

  Exam.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    title = json['title'] ?? "";
    duration = int.tryParse(json['duration'].toString()) ?? 0;
    markPerQuestion = int.tryParse(json['mark_per_question'].toString()) ?? 0;
    passMarks = int.tryParse(json['pass_marks'].toString()) ?? 0;
    questionCount = int.tryParse(json['question_count'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['duration'] = duration;
    data['mark_per_question'] = markPerQuestion;
    data['pass_marks'] = passMarks;
    data['question_count'] = questionCount;
    return data;
  }
}