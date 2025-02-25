// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountModelAdapter extends TypeAdapter<CountModel> {
  @override
  final int typeId = 1;

  @override
  CountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountModel(
      id: fields[0] as String,
      projectId: fields[1] as int,
      description: fields[2] as String,
      controlGuid: fields[3] as String,
      isSend: fields[4] as bool,
      lines: (fields[5] as List).cast<LineModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CountModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projectId)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.controlGuid)
      ..writeByte(4)
      ..write(obj.isSend)
      ..writeByte(5)
      ..write(obj.lines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
