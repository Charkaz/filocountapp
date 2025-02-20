import 'package:flutter/material.dart';
import 'package:birincisayim/features/counter/data/models/count_model.dart';
import 'package:uuid/uuid.dart';

import '../../../project/data/models/project_model.dart';
import '../../../counter/domain/usecases/CountService.dart';

class CounterPage extends StatefulWidget {
  final ProjectModel project;

  const CounterPage({required this.project, super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sayım - ${widget.project.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir açıklama girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final uuid = Uuid();

                    // Get current counts to determine next ID
                    final counts = await CountService.listCounts();
                    final nextId = counts.isEmpty ? 1 : counts.length + 1;

                    final count = CountModel(
                      id: nextId,
                      projectId: widget.project.id,
                      controlGuid: uuid.v4(),
                      description: _descriptionController.text,
                      isSend: false,
                      lines: [],
                    );
                    // Save count
                    await CountService.insert(count);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Sayım Başlat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
