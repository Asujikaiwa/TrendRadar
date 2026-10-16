import 'dart:math';

import '../domain/trend.dart';

/// Contract every trend data source must satisfy.
///
/// The presentation layer depends only on this interface, so we can swap the
/// [MockTrendRepository] for a Supabase-backed implementation later without
/// touching any UI or provider code.
abstract interface class TrendRepository {
  Future<List<Trend>> fetchTrending();
  Future<Trend?> fetchById(String id);
  Future<List<Trend>> search(String query);
}

/// Deterministic in-memory implementation used until the backend is wired up,
/// and for widget/golden tests. Data is stable across calls (seeded), with a
/// small artificial latency so loading/skeleton states are exercised.
class MockTrendRepository implements TrendRepository {
  MockTrendRepository();

  static final List<Trend> _seed = _buildSeed();

  @override
  Future<List<Trend>> fetchTrending() async {
    await _latency();
    final sorted = [..._seed]
      ..sort((a, b) => b.growthPercent.compareTo(a.growthPercent));
    return sorted;
  }

  @override
  Future<Trend?> fetchById(String id) async {
    await _latency();
    for (final t in _seed) {
      if (t.id == id) return t;
    }
    return null;
  }

  @override
  Future<List<Trend>> search(String query) async {
    await _latency();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return _seed.where((t) {
      final haystack = [
        t.title,
        t.summary,
        ...t.relatedKeywords,
      ].join(' ').toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  Future<void> _latency() =>
      Future<void>.delayed(const Duration(milliseconds: 350));

  static List<Trend> _buildSeed() {
    final rng = Random(42); // Fixed seed → deterministic fixtures.

    List<double> series(double start, double end) {
      final points = <double>[];
      for (var i = 0; i < 30; i++) {
        final t = i / 29;
        final base = start + (end - start) * t;
        final noise = (rng.nextDouble() - 0.5) * 8;
        points.add((base + noise).clamp(0, 100).toDouble());
      }
      return points;
    }

    return [
      Trend(
        id: 'matcha-whisk',
        title: 'ชุดชงมัทฉะ',
        category: TrendCategory.product,
        summary:
            'กระแสคาเฟ่มัทฉะทำเองที่บ้านดันยอดค้นหาชุดแปรงชง (chasen) พุ่งต่อเนื่อง',
        growthPercent: 182,
        interest: series(20, 95),
        relatedKeywords: const ['matcha', 'chasen', 'คาเฟ่ที่บ้าน', 'ผงมัทฉะ'],
        isProOnly: false,
      ),
      Trend(
        id: 'labubu-keychain',
        title: 'พวงกุญแจ Labubu',
        category: TrendCategory.product,
        summary: 'ของสะสม art toy ยังแรง กลุ่มมือใหม่หาซื้อรุ่นเริ่มต้นราคาถูก',
        growthPercent: 140,
        interest: series(35, 88),
        relatedKeywords: const ['art toy', 'popmart', 'ของสะสม', 'blind box'],
        isProOnly: false,
      ),
      Trend(
        id: 'cooling-blanket',
        title: 'ผ้าห่มเย็น',
        category: TrendCategory.keyword,
        summary: 'อากาศร้อนดันดีมานด์สินค้าคลายร้อน ค้นหาพีคช่วงกลางวัน',
        growthPercent: 76,
        interest: series(40, 72),
        relatedKeywords: const ['หน้าร้อน', 'ผ้าห่มนาโน', 'ของใช้ในบ้าน'],
        isProOnly: false,
      ),
      Trend(
        id: 'viral-sound-th',
        title: '#เสียงไวรัลร้านค้า',
        category: TrendCategory.hashtag,
        summary:
            'แฮชแท็กเสียงประกอบคลิปรีวิวสินค้ากำลังถูกใช้ซ้ำในสาย e-commerce',
        growthPercent: 58,
        interest: series(30, 65),
        relatedKeywords: const ['tiktok', 'รีวิวสินค้า', 'คอนเทนต์ขายของ'],
        isProOnly: true,
      ),
      Trend(
        id: 'protein-snack',
        title: 'ขนมโปรตีนสูง',
        category: TrendCategory.product,
        summary: 'เทรนด์สายเฮลตี้หนุนขนมโปรตีน กลุ่มคนออกกำลังกายเป็นหลัก',
        growthPercent: 44,
        interest: series(28, 60),
        relatedKeywords: const ['healthy', 'โปรตีนบาร์', 'ลดน้ำหนัก'],
        isProOnly: false,
      ),
      Trend(
        id: 'mini-printer',
        title: 'เครื่องปริ้นสติกเกอร์พกพา',
        category: TrendCategory.product,
        summary: 'สาย DIY และแม่ค้าใช้พิมพ์ฉลาก/สติกเกอร์ ยอดค้นหาค่อย ๆ ไต่',
        growthPercent: 31,
        interest: series(22, 50),
        relatedKeywords: const ['สติกเกอร์', 'ฉลากสินค้า', 'diy', 'แพ็คของ'],
        isProOnly: true,
      ),
    ];
  }
}
