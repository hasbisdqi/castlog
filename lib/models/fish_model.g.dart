// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fish_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FishModelAdapter extends TypeAdapter<FishModel> {
  @override
  final int typeId = 0;

  @override
  FishModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FishModel(
      name: fields[0] as String,
      category: fields[1] as String,
      image: fields[2] as String,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FishModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FishModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
