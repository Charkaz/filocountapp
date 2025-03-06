import 'package:birincisayim/features/counter/data/models/count_model.dart';
import 'package:birincisayim/features/line/presentation/pages/lines_page.dart';
import 'package:birincisayim/features/counter/domain/usecases/count_service.dart';
import 'package:birincisayim/features/counter/data/repositories/post_count.dart';
import 'package:birincisayim/features/line/domain/repositories/line_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountList extends StatefulWidget {
  final List<CountModel> counts;
  final VoidCallback onCountDeleted;
  final LineRepository lineRepository;

  const CountList({
    required this.counts,
    required this.onCountDeleted,
    required this.lineRepository,
    super.key,
  });

  @override
  _CountListState createState() => _CountListState();
}

class _CountListState extends State<CountList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.counts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final count = widget.counts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D3A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[850]!,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LinesPage(count: count),
                    ),
                  );
                },
                onLongPress: () => _showOptionsDialog(context, count),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: count.isSend
                                  ? Colors.green.withOpacity(0.1)
                                  : const Color(0xFF3E3E4A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: count.isSend
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.blue.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              count.isSend
                                  ? Icons.cloud_done_rounded
                                  : Icons.inventory_2_outlined,
                              color: count.isSend ? Colors.green : Colors.blue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  count.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: count.isSend
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              count.isSend
                                                  ? Icons.check_circle_outline
                                                  : Icons.pending_outlined,
                                              size: 14,
                                              color: count.isSend
                                                  ? Colors.green
                                                  : Colors.orange[700],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              count.isSend
                                                  ? "Aktarıldı"
                                                  : "Beklemede",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: count.isSend
                                                    ? Colors.green
                                                    : Colors.orange[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF3E3E4A),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.tag,
                                              size: 14,
                                              color: Colors.white70,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "ID: ${count.id}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showUploadDialog(BuildContext context, CountModel count) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Merkeze Aktar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Bu sayımı merkeze aktarmak istediğinize emin misiniz?',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _uploadCount(context, count),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Aktar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadCount(BuildContext context, CountModel count) async {
    try {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
            backgroundColor: Color(0xFF2A2A2A),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'Merkeze aktarılıyor...',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

      final statusCode = await PostCount.post(count, widget.lineRepository);

      if (statusCode == 201) {
        // Başarılı - Sayımı güncelle
        await CountService.updateCount(count.copyWith(isSend: true));

        if (context.mounted) {
          Navigator.pop(context); // Yükleme göstergesini kapat
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sayım başarıyla aktarıldı"),
              backgroundColor: Colors.green,
            ),
          );
          widget.onCountDeleted(); // Listeyi yenile
        }
      } else if (statusCode == 400) {
        throw Exception('Geçersiz istek: Lütfen verilerinizi kontrol edin');
      } else if (statusCode == 500) {
        throw Exception('Sunucu hatası: Lütfen daha sonra tekrar deneyin');
      } else {
        throw Exception('Beklenmeyen bir hata oluştu (Kod: $statusCode)');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Yükleme göstergesini kapat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context, CountModel count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Sayımı Sil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          '${count.description} sayımını silmek istediğinize emin misiniz?',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await CountService.deleteCount(count.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  widget.onCountDeleted();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sayım başarıyla silindi'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hata: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sil',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, CountModel count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3E3E4A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'İşlemler',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!count.isSend) ...[
              ListTile(
                leading: const Icon(Icons.cloud_upload, color: Colors.blue),
                title: const Text(
                  'Merkeze Aktar',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showUploadDialog(context, count);
                },
              ),
              const Divider(color: Colors.grey),
            ],
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Sil',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(context, count);
              },
            ),
          ],
        ),
      ),
    );
  }
}
