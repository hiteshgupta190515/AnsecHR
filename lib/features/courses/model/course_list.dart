import 'package:ready_lms/features/courses/model/course_detail.dart';

class CourseListModel {
  CourseListModel({
    required this.id,
    required this.category,
    required this.title,
    required this.thumbnail,
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
    required this.isFavourite,
    this.submittedReview,
    required this.isEnrolled,
    required this.isReviewed,
    required this.canReview,
    required this.isFree,
  });
  late final int id;
  late final String category;
  late final String title;
  late final String thumbnail;
  late final int viewCount;
  var regularPrice;
  var price;
  late final Instructor instructor;
  late final dynamic publishedAt;
  late final int totalDuration;
  late final int videoCount;
  late final int noteCount;
  late final int audioCount;
  late final int chapterCount;
  late final int studentCount;
  late final int reviewCount;
  SubmittedReview? submittedReview;
  var averageRating;
  late final bool isFavourite;
  late final bool isEnrolled;
  late final bool isReviewed;
  late bool canReview;
  var isCompleted;
  late final bool? isFree;

  CourseListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    
    // FIX 1: Safe parsing for integers sent as strings
    viewCount = int.parse(json['view_count'].toString());
    
    regularPrice = json['regular_price'];
    price = json['price'];
    instructor = Instructor.fromJson(json['instructor']);
    
    if (json['submitted_review'] != null) {
      submittedReview = SubmittedReview.fromJson(json['submitted_review']);
    }
    
    publishedAt = json['published_at'];
    totalDuration = int.parse(json['total_duration'].toString());
    videoCount = int.parse(json['video_count'].toString());
    noteCount = int.parse(json['note_count'].toString());
    audioCount = int.parse(json['audio_count'].toString());
    chapterCount = int.parse(json['chapter_count'].toString());
    studentCount = int.parse(json['student_count'].toString());
    reviewCount = int.parse(json['review_count'].toString());
    
    averageRating = json['average_rating'];
    isFavourite = json['is_favourite'] ?? false;
    isEnrolled = json['is_enrolled'] ?? false;
    isReviewed = json['is_reviewed'] ?? false;
    canReview = json['can_review'] ?? false;
    isCompleted = json['is_completed'] ?? false;
    isFree = json['is_free'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['title'] = title;
    data['thumbnail'] = thumbnail;
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
    data['is_completed'] = isCompleted;
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
    id = json['id'];
    name = json['name'];
    profilePicture = json['profile_picture'];
    title = json['title'];
    isFeatured = int.parse(json['is_featured'].toString());
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
