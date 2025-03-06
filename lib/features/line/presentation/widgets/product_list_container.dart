import 'package:flutter/material.dart';
import '../../../counter/data/models/count_model.dart';
import '../bloc/line_bloc.dart';
import './line_list.dart';

class ProductListContainer extends StatelessWidget {
  final CountModel count;
  final LinesBloc bloc;

  const ProductListContainer({
    super.key,
    required this.count,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border(
            top: BorderSide(
              color: Colors.grey[900]!,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ürünler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.insights,
                          size: 16,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'İstatistikler',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LineList(
                bloc: bloc,
                count: count,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
