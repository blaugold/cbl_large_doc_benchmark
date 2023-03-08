import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:cbl_large_doc_benchmark/benchmark.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CouchbaseLiteFlutter.init();
  await runBenchmark();
}
