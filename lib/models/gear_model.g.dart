// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gear_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GearModelAdapter extends TypeAdapter<GearModel> {
  @override
  final int typeId = 1;

  @override
  GearModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GearModel(
      name: fields[0] as String,
      category: fields[1] as String,
      subCategory: fields[2] as String,
      image: fields[3] as String,
      description: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GearModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.subCategory)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GearModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
