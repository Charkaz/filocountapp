import 'package:flutter/material.dart';
import '../../data/models/count_model.dart';

class CountList extends StatelessWidget {
  final List<CountModel> counts;

  const CountList({required this.counts, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: counts.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final count = counts[index];
        return ListTile(
          title: Text(count.description),
          subtitle: Text('Sayım ID: ${count.id}'),
          trailing: Icon(
            count.isSend ? Icons.cloud_done : Icons.cloud_off,
            color: count.isSend ? Colors.green : Colors.grey,
          ),
        );
      },
    );
  }
}
