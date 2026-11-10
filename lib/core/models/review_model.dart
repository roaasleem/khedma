class ReviewModel {
  final String id;
  final String workerId;
  final String customerId;
  final String customerName;
  final double rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.workerId,
    required this.customerId,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
