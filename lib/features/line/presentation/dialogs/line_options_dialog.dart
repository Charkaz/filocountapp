import 'package:flutter/material.dart';
import '../../domain/entities/line_entity.dart';
import '../bloc/line_bloc.dart';
import 'line_delete_dialog.dart';

class LineOptionsDialog extends StatelessWidget {
  final LineEntity line;
  final LinesBloc bloc;
  final String countId;

  const LineOptionsDialog({
    required this.line,
    required this.bloc,
    required this.countId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController quantityController =
        TextEditingController(text: line.quantity.toString());

    return AlertDialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Ürün İşlemleri',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Miktar',
              labelStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.save, color: Colors.blue),
            title: const Text('Kaydet', style: TextStyle(color: Colors.white)),
            onTap: () async {
              final newQuantity =
                  double.parse(quantityController.text.replaceAll(',', '.'));
              if (newQuantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("miqdar menfi ola bilmez")),
                );
              }
              bloc.add(UpdateQuantityEvent(
                id: line.id,
                countId: countId,
                quantity: newQuantity,
              ));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Sil', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => LineDeleteDialog(
                  line: line,
                  bloc: bloc,
                  countId: countId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
