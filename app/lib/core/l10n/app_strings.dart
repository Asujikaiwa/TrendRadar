/// Typed string table for a single locale.
///
/// We hand-author this instead of relying on generated ARB delegates so the
/// project compiles and runs with zero codegen. When the copy set stabilizes,
/// this can be swapped for `flutter gen-l10n` without changing call sites
/// (they all go through `AppStrings.of(context)`).
class AppStrings {
  const AppStrings({
    required this.appName,
    required this.tabFeed,
    required this.tabSearch,
    required this.tabSaved,
    required this.tabSettings,
    required this.feedTitle,
    required this.feedSubtitle,
    required this.risingBadge,
    required this.searchHint,
    required this.searchEmpty,
    required this.savedTitle,
    required this.savedEmpty,
    required this.settingsTitle,
    required this.settingsLanguage,
    required this.settingsTheme,
    required this.settingsThemeSystem,
    required this.settingsThemeLight,
    required this.settingsThemeDark,
    required this.settingsUpgrade,
    required this.settingsDeleteAccount,
    required this.detailInterest,
    required this.detailRelated,
    required this.detailSave,
    required this.detailSaved,
    required this.proLocked,
    required this.proUnlockCta,
    required this.errorGeneric,
    required this.retry,
    required this.offlineBanner,
  });

  final String appName;
  final String tabFeed;
  final String tabSearch;
  final String tabSaved;
  final String tabSettings;
  final String feedTitle;
  final String feedSubtitle;
  final String risingBadge;
  final String searchHint;
  final String searchEmpty;
  final String savedTitle;
  final String savedEmpty;
  final String settingsTitle;
  final String settingsLanguage;
  final String settingsTheme;
  final String settingsThemeSystem;
  final String settingsThemeLight;
  final String settingsThemeDark;
  final String settingsUpgrade;
  final String settingsDeleteAccount;
  final String detailInterest;
  final String detailRelated;
  final String detailSave;
  final String detailSaved;
  final String proLocked;
  final String proUnlockCta;
  final String errorGeneric;
  final String retry;
  final String offlineBanner;
}

/// Thai — primary market.
const kStringsTh = AppStrings(
  appName: 'TrendRadar',
  tabFeed: 'เทรนด์',
  tabSearch: 'ค้นหา',
  tabSaved: 'บันทึกไว้',
  tabSettings: 'ตั้งค่า',
  feedTitle: 'เทรนด์ที่กำลังมา',
  feedSubtitle: 'สินค้าและคีย์เวิร์ดที่กำลังพุ่งในไทย',
  risingBadge: 'กำลังพุ่ง',
  searchHint: 'ค้นหาสินค้า คีย์เวิร์ด หรือแฮชแท็ก',
  searchEmpty: 'พิมพ์เพื่อค้นหาเทรนด์',
  savedTitle: 'เทรนด์ที่บันทึกไว้',
  savedEmpty: 'ยังไม่มีเทรนด์ที่บันทึก — แตะรูปหัวใจเพื่อเก็บไว้ดูภายหลัง',
  settingsTitle: 'ตั้งค่า',
  settingsLanguage: 'ภาษา',
  settingsTheme: 'ธีม',
  settingsThemeSystem: 'ตามระบบ',
  settingsThemeLight: 'สว่าง',
  settingsThemeDark: 'มืด',
  settingsUpgrade: 'อัปเกรดเป็น Pro',
  settingsDeleteAccount: 'ลบบัญชี',
  detailInterest: 'ความสนใจ 30 วัน',
  detailRelated: 'คีย์เวิร์ดที่เกี่ยวข้อง',
  detailSave: 'บันทึก',
  detailSaved: 'บันทึกแล้ว',
  proLocked: 'ข้อมูลเชิงลึกนี้สำหรับสมาชิก Pro',
  proUnlockCta: 'ปลดล็อกด้วย Pro',
  errorGeneric: 'เกิดข้อผิดพลาด ลองใหม่อีกครั้ง',
  retry: 'ลองใหม่',
  offlineBanner: 'ออฟไลน์ — กำลังแสดงข้อมูลที่บันทึกไว้',
);

/// English — international fallback.
const kStringsEn = AppStrings(
  appName: 'TrendRadar',
  tabFeed: 'Trends',
  tabSearch: 'Search',
  tabSaved: 'Saved',
  tabSettings: 'Settings',
  feedTitle: 'Rising trends',
  feedSubtitle: 'Products & keywords gaining momentum in Thailand',
  risingBadge: 'Rising',
  searchHint: 'Search products, keywords or hashtags',
  searchEmpty: 'Type to search trends',
  savedTitle: 'Saved trends',
  savedEmpty: 'No saved trends yet — tap the heart to keep one for later',
  settingsTitle: 'Settings',
  settingsLanguage: 'Language',
  settingsTheme: 'Theme',
  settingsThemeSystem: 'System',
  settingsThemeLight: 'Light',
  settingsThemeDark: 'Dark',
  settingsUpgrade: 'Upgrade to Pro',
  settingsDeleteAccount: 'Delete account',
  detailInterest: '30-day interest',
  detailRelated: 'Related keywords',
  detailSave: 'Save',
  detailSaved: 'Saved',
  proLocked: 'This deep-dive is for Pro members',
  proUnlockCta: 'Unlock with Pro',
  errorGeneric: 'Something went wrong. Please try again.',
  retry: 'Retry',
  offlineBanner: 'Offline — showing saved data',
);

/// Simplified Chinese — future market (language support ships in MVP).
const kStringsZh = AppStrings(
  appName: 'TrendRadar',
  tabFeed: '趋势',
  tabSearch: '搜索',
  tabSaved: '已保存',
  tabSettings: '设置',
  feedTitle: '上升趋势',
  feedSubtitle: '泰国正在升温的商品与关键词',
  risingBadge: '上升中',
  searchHint: '搜索商品、关键词或话题标签',
  searchEmpty: '输入以搜索趋势',
  savedTitle: '已保存的趋势',
  savedEmpty: '暂无保存的趋势 — 点击爱心即可收藏',
  settingsTitle: '设置',
  settingsLanguage: '语言',
  settingsTheme: '主题',
  settingsThemeSystem: '跟随系统',
  settingsThemeLight: '浅色',
  settingsThemeDark: '深色',
  settingsUpgrade: '升级到 Pro',
  settingsDeleteAccount: '删除账户',
  detailInterest: '30 天热度',
  detailRelated: '相关关键词',
  detailSave: '保存',
  detailSaved: '已保存',
  proLocked: '此深度洞察为 Pro 会员专享',
  proUnlockCta: '解锁 Pro',
  errorGeneric: '出错了，请重试。',
  retry: '重试',
  offlineBanner: '离线 — 正在显示已保存的数据',
);
