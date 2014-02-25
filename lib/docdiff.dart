library docdiff;

part 'src/elements.dart';
part 'src/comparison.dart';
part 'src/renderer.dart';

abstract class JsonSerializable {
  Map<String, Object> toJson();
}

Map<String, Object> _toJson(JsonSerializable obj) => 
    obj == null ? null : obj.toJson();