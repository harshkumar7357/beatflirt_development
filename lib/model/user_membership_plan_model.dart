class UserMembershipPlanModel {
  final String status;
  final String membershipId;
  final String? membershipExpire;
  final UserPlanData? data;
  final String? message;

  UserMembershipPlanModel({
    required this.status,
    required this.membershipId,
    this.membershipExpire,
    this.data,
    this.message,
  });

  factory UserMembershipPlanModel.fromJson(Map<String, dynamic> json) {
    return UserMembershipPlanModel(
      status: json['status']?.toString() ?? '',
      membershipId: json['membership_id']?.toString() ?? '0',
      membershipExpire: json['membership_expire']?.toString(),
      data: json['data'] != null ? UserPlanData.fromJson(json['data']) : null,
      message: json['message']?.toString(),
    );
  }

  bool get hasActivePlan => status == '200' && data != null;
}

class UserPlanData {
  final String id;
  final String membershipId;
  final String userId;
  final String transactionId;
  final String orderId;
  final String planName;
  final String planPrice;
  final String planYear;
  final String paymentStatus;
  final String paymentDate;
  final String planValidFromDate;
  final String planValidToDate;
  final String status;
  final String created;

  UserPlanData({
    required this.id,
    required this.membershipId,
    required this.userId,
    required this.transactionId,
    required this.orderId,
    required this.planName,
    required this.planPrice,
    required this.planYear,
    required this.paymentStatus,
    required this.paymentDate,
    required this.planValidFromDate,
    required this.planValidToDate,
    required this.status,
    required this.created,
  });

  factory UserPlanData.fromJson(Map<String, dynamic> json) {
    return UserPlanData(
      id: json['id']?.toString() ?? '',
      membershipId: json['membership_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      transactionId: json['transaction_id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      planName: json['plan_name']?.toString() ?? '',
      planPrice: json['plan_price']?.toString() ?? '',
      planYear: json['plan_year']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      paymentDate: json['payment_date']?.toString() ?? '',
      planValidFromDate: json['plan_valid_from_date']?.toString() ?? '',
      planValidToDate: json['plan_valid_to_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
    );
  }
}
