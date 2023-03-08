import 'package:cbl_large_doc_benchmark/json_generator.dart';
import 'package:cbl_large_doc_benchmark/json_utils.dart';

void main(List<String> arguments) {
  final entries = int.parse(arguments[0]);
  final jsonGenerator = JsonGenerator();
  final data = {
    for (var i = 0; i < entries; i++) 'key$i': jsonGenerator.generateObject(),
  };
  // ignore: avoid_print
  print(prettyJson(data));
}
