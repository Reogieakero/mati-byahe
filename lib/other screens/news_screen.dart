import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';
import '../../core/models/news_article.dart';
import '../../core/services/news_api_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiService _apiService = NewsApiService();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8FAFC,
      ), // Matches TrackingScreen background
      body: Column(
        children: [
          _buildHeader(), // Now matches HomeHeader styling
          _buildSearchBar(),
          Expanded(
            child: FutureBuilder<List<NewsArticle>>(
              future: _apiService.fetchNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _query.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.darkNavy),
                  );
                }

                final articles = (snapshot.data ?? []).where((a) {
                  final searchLower = _query.toLowerCase();
                  return a.title.toLowerCase().contains(searchLower) ||
                      a.description.toLowerCase().contains(searchLower);
                }).toList();

                return RefreshIndicator(
                  color: AppColors.darkNavy,
                  onRefresh: () async => setState(() {}),
                  child: articles.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal:
                                16, // Consistent with tracking list padding
                            vertical: 10,
                          ),
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: articles.length,
                          itemBuilder: (context, index) =>
                              _newsCard(articles[index]),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 15),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.darkNavy,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text(
            'WORLD NEWS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.darkNavy,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value.trim()),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: "Search updates...",
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppColors.darkNavy,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _newsCard(NewsArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          20,
        ), // Matches summary cards and trip tiles
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  article.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.darkNavy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  article.source.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                article.pubDate.split(' ')[0],
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            article.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            article.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              height: 1.4,
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No news available.", style: TextStyle(color: Colors.grey)),
    );
  }
}
