class NotificationModel {
  final int ticketId;
  final String title;
  final String message;
  final String role;
  final DateTime createdAt;

  NotificationModel({
    required this.ticketId,
    required this.title,
    required this.message,
    required this.role,
    required this.createdAt,
  });
}