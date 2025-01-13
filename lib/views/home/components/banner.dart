import 'package:flutter/material.dart';
import '../../../networks/api_banners.dart';
import 'banner_detail.dart';

class BannerSlide extends StatefulWidget {
  const BannerSlide({super.key});

  @override
  State<BannerSlide> createState() => _BannerSlideState();
}

class _BannerSlideState extends State<BannerSlide> {
  Future<List<Map<String, dynamic>>>? _bannerData;

  @override
  void initState() {
    super.initState();
    _bannerData = ApiBanners.getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _bannerData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Gagal memuat banner: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Tidak ada banner untuk ditampilkan'),
          );
        }

        final bannerData = snapshot.data!;

        return SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: bannerData.length,
            itemBuilder: (context, index) {
              final banner = bannerData[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BannerDetailPage(
                        imageUrl: banner['image']!,
                        description: banner['description']!,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        banner['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
