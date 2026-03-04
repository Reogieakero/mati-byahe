import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<_NewsItem> _stories = [
    _NewsItem(
      title: 'Fare Matrix 2026',
      body: 'Updated city-approved taripa rates are now active in-app.',
      dateLabel: 'Today',
      category: 'Policy',
      isPinned: true,
    ),
    _NewsItem(
      title: 'Driver Safety Seminar',
      body: 'Mandatory seminar for all active drivers this Saturday.',
      dateLabel: 'Mar 1',
      category: 'Safety',
    ),
    _NewsItem(
      title: 'Feature: Smart Route Scan',
      body: 'Passengers can now scan and auto-fill pickup/drop quickly.',
      dateLabel: 'Feb 28',
      category: 'Product',
    ),
    _NewsItem(
      title: 'Terminal Advisory',
      body: 'Road works near terminal gate A may cause 5-10 minute delays.',
      dateLabel: 'Feb 26',
      category: 'Advisory',
    ),
  ];

  String _activeCategory = 'All';
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = _filteredStories();
    final savedCount = _stories.where((s) => s.isSaved).length;

    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _topBanner(savedCount: savedCount),
            const SizedBox(height: 12),
            _searchField(),
            const SizedBox(height: 10),
            _categoryChips(),
            const SizedBox(height: 12),
            if (stories.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    'No announcements found.',
                    style: TextStyle(color: Color(0xFF63778F)),
                  ),
                ),
              )
            else
              ...stories.map(_storyCard),
          ],
        ),
      ),
    );
  }

  Widget _topBanner({required int savedCount}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF17273B), Color(0xFF18A0FB)],
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Official Updates',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Track advisories, policy changes, and release notes.',
                  style: TextStyle(color: Color(0xFFD8E9FF), height: 1.3),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x33FFFFFF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$savedCount saved',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
      decoration: InputDecoration(
        hintText: 'Search news',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                icon: const Icon(Icons.close),
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _categoryChips() {
    const categories = ['All', 'Policy', 'Safety', 'Product', 'Advisory'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final active = _activeCategory == category;
        return InkWell(
          onTap: () => setState(() => _activeCategory = category),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF17273B) : const Color(0xFFEFF4FA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF4A5C74),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _storyCard(_NewsItem story) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE7F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (story.isPinned)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(Icons.push_pin, size: 16, color: Color(0xFF1466B3)),
                ),
              Expanded(
                child: Text(
                  story.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17273B),
                  ),
                ),
              ),
              Text(
                story.dateLabel,
                style: const TextStyle(fontSize: 12, color: Color(0xFF647992)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            story.body,
            style: const TextStyle(height: 1.35, color: Color(0xFF4E6279)),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _chip(story.category),
              const Spacer(),
              IconButton(
                icon: Icon(
                  story.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: story.isSaved
                      ? const Color(0xFF1466B3)
                      : const Color(0xFF7C8FA6),
                ),
                onPressed: () => setState(() => story.isSaved = !story.isSaved),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF36506F),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  List<_NewsItem> _filteredStories() {
    final out = _stories.where((story) {
      final categoryPass = _activeCategory == 'All' || story.category == _activeCategory;
      final queryPass =
          _query.isEmpty ||
          story.title.toLowerCase().contains(_query) ||
          story.body.toLowerCase().contains(_query);
      return categoryPass && queryPass;
    }).toList();

    out.sort((a, b) {
      if (a.isPinned == b.isPinned) return 0;
      return a.isPinned ? -1 : 1;
    });

    return out;
  }

  Future<void> _refreshFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    setState(() {
      _stories.insert(
        0,
        _NewsItem(
          title: 'Service Availability Update',
          body: 'Driver network recovered to normal levels after maintenance.',
          dateLabel: 'Just now',
          category: 'Advisory',
          isPinned: true,
        ),
      );
    });
  }
}

class _NewsItem {
  _NewsItem({
    required this.title,
    required this.body,
    required this.dateLabel,
    required this.category,
    this.isPinned = false,
  });

  final String title;
  final String body;
  final String dateLabel;
  final String category;
  final bool isPinned;
  bool isSaved = false;
}
