class MembershipModel {
  final String id;
  final String headingTitleName;
  final String headingTitlePrice;
  final String headingTitlePlan;
  final String subHeading1Price;
  final String subHeading1Title;
  final String subHeading2Price;
  final String subHeading2Title;
  final String content;

  MembershipModel({
    required this.id,
    required this.headingTitleName,
    required this.headingTitlePrice,
    required this.headingTitlePlan,
    required this.subHeading1Price,
    required this.subHeading1Title,
    required this.subHeading2Price,
    required this.subHeading2Title,
    required this.content,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      id: json['id']?.toString() ?? '',
      headingTitleName: json['heading_title_name']?.toString() ?? '',
      headingTitlePrice: json['heading_title_price']?.toString() ?? '',
      headingTitlePlan: json['heading_title_plan']?.toString() ?? '',
      subHeading1Price: json['sub_heading1_price']?.toString() ?? '',
      subHeading1Title: json['sub_heading1_title']?.toString() ?? '',
      subHeading2Price: json['sub_heading2_price']?.toString() ?? '',
      subHeading2Title: json['sub_heading2_title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heading_title_name': headingTitleName,
      'heading_title_price': headingTitlePrice,
      'heading_title_plan': headingTitlePlan,
      'sub_heading1_price': subHeading1Price,
      'sub_heading1_title': subHeading1Title,
      'sub_heading2_price': subHeading2Price,
      'sub_heading2_title': subHeading2Title,
      'content': content,
    };
  }
}
