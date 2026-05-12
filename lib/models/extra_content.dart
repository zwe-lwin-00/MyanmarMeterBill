/// Content for the “device power” knowledge tab (from JSON `deviceGuide`).
class DeviceGuideContent {
  const DeviceGuideContent({
    required this.pageTitle,
    required this.intro,
    required this.items,
  });

  final String pageTitle;
  final String intro;
  final List<DeviceGuideItem> items;

  Map<String, Object?> toJson() => {
        'pageTitle': pageTitle,
        'intro': intro,
        'items': items.map((e) => e.toJson()).toList(),
      };

  static DeviceGuideContent fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('deviceGuide must be an object');
    }
    final pageTitle = (json['pageTitle'] as String? ?? '').trim();
    final intro = (json['intro'] as String? ?? '').trim();
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = <DeviceGuideItem>[];
    for (final row in rawItems) {
      if (row is! Map<String, dynamic>) continue;
      items.add(DeviceGuideItem.fromJson(row));
    }
    return DeviceGuideContent(
      pageTitle: pageTitle,
      intro: intro,
      items: items,
    );
  }
}

class DeviceGuideItem {
  const DeviceGuideItem({
    required this.title,
    this.typicalWatts,
    required this.notes,
  });

  final String title;
  final int? typicalWatts;
  final String notes;

  Map<String, Object?> toJson() => {
        'title': title,
        if (typicalWatts != null) 'typicalWatts': typicalWatts,
        'notes': notes,
      };

  static DeviceGuideItem fromJson(Map<String, dynamic> json) {
    final w = json['typicalWatts'] as num?;
    return DeviceGuideItem(
      title: (json['title'] as String? ?? '').trim(),
      typicalWatts: w?.round(),
      notes: (json['notes'] as String? ?? '').trim(),
    );
  }
}

/// Content for the “about developer” tab (from JSON `aboutDeveloper`).
class AboutDeveloperContent {
  const AboutDeveloperContent({
    required this.pageTitle,
    required this.paragraphs,
    required this.developerName,
    this.role,
    this.linkLabel,
    this.linkUrl,
    this.portfolioLabel,
    this.portfolioUrl,
    this.phoneLabel,
    this.phone,
    this.emailLabel,
    this.email,
    this.feedbackTitle,
    this.feedbackMessage,
  });

  final String pageTitle;
  final List<String> paragraphs;
  final String developerName;
  final String? role;
  final String? linkLabel;
  final String? linkUrl;
  final String? portfolioLabel;
  final String? portfolioUrl;
  final String? phoneLabel;
  final String? phone;
  final String? emailLabel;
  final String? email;
  final String? feedbackTitle;
  final String? feedbackMessage;

  Map<String, Object?> toJson() => {
        'pageTitle': pageTitle,
        'paragraphs': paragraphs,
        'developerName': developerName,
        if (role != null) 'role': role,
        if (linkLabel != null) 'linkLabel': linkLabel,
        if (linkUrl != null) 'linkUrl': linkUrl,
        if (portfolioLabel != null) 'portfolioLabel': portfolioLabel,
        if (portfolioUrl != null) 'portfolioUrl': portfolioUrl,
        if (phoneLabel != null) 'phoneLabel': phoneLabel,
        if (phone != null) 'phone': phone,
        if (emailLabel != null) 'emailLabel': emailLabel,
        if (email != null) 'email': email,
        if (feedbackTitle != null) 'feedbackTitle': feedbackTitle,
        if (feedbackMessage != null) 'feedbackMessage': feedbackMessage,
      };

  static AboutDeveloperContent fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('aboutDeveloper must be an object');
    }
    final pageTitle = (json['pageTitle'] as String? ?? '').trim();
    final name = (json['developerName'] as String? ?? '').trim();
    final roleRaw = (json['role'] as String?)?.trim();
    final linkLabelRaw = (json['linkLabel'] as String?)?.trim();
    final linkUrlRaw = (json['linkUrl'] as String?)?.trim();
    final portfolioLabelRaw = (json['portfolioLabel'] as String?)?.trim();
    final portfolioUrlRaw = (json['portfolioUrl'] as String?)?.trim();
    final phoneLabelRaw = (json['phoneLabel'] as String?)?.trim();
    final phoneRaw = (json['phone'] as String?)?.trim();
    final emailLabelRaw = (json['emailLabel'] as String?)?.trim();
    final emailRaw = (json['email'] as String?)?.trim();
    final feedbackTitleRaw = (json['feedbackTitle'] as String?)?.trim();
    final feedbackMessageRaw = (json['feedbackMessage'] as String?)?.trim();
    final rawParas = json['paragraphs'] as List<dynamic>? ?? [];
    final paragraphs = rawParas.map((e) => e.toString()).toList();
    return AboutDeveloperContent(
      pageTitle: pageTitle,
      paragraphs: paragraphs,
      developerName: name,
      role: (roleRaw == null || roleRaw.isEmpty) ? null : roleRaw,
      linkLabel: (linkLabelRaw == null || linkLabelRaw.isEmpty) ? null : linkLabelRaw,
      linkUrl: (linkUrlRaw == null || linkUrlRaw.isEmpty) ? null : linkUrlRaw,
      portfolioLabel:
          (portfolioLabelRaw == null || portfolioLabelRaw.isEmpty)
              ? null
              : portfolioLabelRaw,
      portfolioUrl:
          (portfolioUrlRaw == null || portfolioUrlRaw.isEmpty)
              ? null
              : portfolioUrlRaw,
      phoneLabel:
          (phoneLabelRaw == null || phoneLabelRaw.isEmpty) ? null : phoneLabelRaw,
      phone: (phoneRaw == null || phoneRaw.isEmpty) ? null : phoneRaw,
      emailLabel:
          (emailLabelRaw == null || emailLabelRaw.isEmpty) ? null : emailLabelRaw,
      email: (emailRaw == null || emailRaw.isEmpty) ? null : emailRaw,
      feedbackTitle:
          (feedbackTitleRaw == null || feedbackTitleRaw.isEmpty)
              ? null
              : feedbackTitleRaw,
      feedbackMessage:
          (feedbackMessageRaw == null || feedbackMessageRaw.isEmpty)
              ? null
              : feedbackMessageRaw,
    );
  }
}
