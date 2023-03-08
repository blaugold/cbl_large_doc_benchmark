import 'package:cbl_dart/cbl_dart.dart';
import 'package:cbl_large_doc_benchmark/benchmark.dart';

void main() async {
  await CouchbaseLiteDart.init(edition: Edition.enterprise, filesDir: '.tmp');
  await runBenchmark();
}
