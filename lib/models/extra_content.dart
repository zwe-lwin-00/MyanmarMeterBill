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
  });

  final String pageTitle;
  final List<String> paragraphs;
  final String developerName;
  final String? role;
  final String? linkLabel;
  final String? linkUrl;

  Map<String, Object?> toJson() => {
        'pageTitle': pageTitle,
        'paragraphs': paragraphs,
        'developerName': developerName,
        if (role != null) 'role': role,
        if (linkLabel != null) 'linkLabel': linkLabel,
        if (linkUrl != null) 'linkUrl': linkUrl,
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
    final rawParas = json['paragraphs'] as List<dynamic>? ?? [];
    final paragraphs = rawParas.map((e) => e.toString()).toList();
    return AboutDeveloperContent(
      pageTitle: pageTitle,
      paragraphs: paragraphs,
      developerName: name,
      role: (roleRaw == null || roleRaw.isEmpty) ? null : roleRaw,
      linkLabel: (linkLabelRaw == null || linkLabelRaw.isEmpty) ? null : linkLabelRaw,
      linkUrl: (linkUrlRaw == null || linkUrlRaw.isEmpty) ? null : linkUrlRaw,
    );
  }
}
