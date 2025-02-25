import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/project_bloc.dart';
import '../../../../features/product/data/services/sync_service.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.sync, color: Colors.blue, size: 20),
          ),
          onPressed: () async {
            try {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              );

              await SyncService.syncAll();

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Veriler başarıyla güncellendi'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<ProjectBloc>().add(LoadProjects());
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
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final top = constraints.biggest.height;
          const expandedHeight = 180.0;
          final shrinkOffset = expandedHeight - top;
          final progress = shrinkOffset / expandedHeight;

          return Container(
            color: Colors.black,
            child: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              background: Container(color: Colors.black),
              title: SvgPicture.asset(
                'assets/logo.svg',
                height: progress < 0.5 ? 60 : 48,
                fit: BoxFit.contain,
              ),
              collapseMode: CollapseMode.parallax,
            ),
          );
        },
      ),
    );
  }
}
