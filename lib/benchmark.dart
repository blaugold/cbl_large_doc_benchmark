import 'package:cbl/cbl.dart';
import 'package:cbl_large_doc_benchmark/csv.dart';
import 'package:cbl_large_doc_benchmark/json_generator.dart';
import 'package:cbl_large_doc_benchmark/json_utils.dart';

final _entrySizes = [
  1,
  ...List.generate(20, (index) => (index + 1) * 10),
];
const _repeats = 10;
const _loadedDocument = true;
const _documentId = 'benchmark';
final _results = <_BenchmarkResult>[];
final _jsonGenerator = JsonGenerator();

Future<void> runBenchmark() async {
  final database = await Database.openAsync('benchmark');

  for (final entries in _entrySizes) {
    await _runBenchmark(
      database: database,
      entries: entries,
      loadedDocument: _loadedDocument,
    );
  }

  await database.close();

  // ignore: avoid_print
  print(formatCsv(_results.toCsv()));
}

Future<void> _runBenchmark({
  required Database database,
  required int entries,
  bool loadedDocument = false,
}) async {
  try {
    await database.purgeDocumentById(_documentId);
    // ignore: avoid_catches_without_on_clauses
  } catch (_) {}

  var document = _createBenchmarkDocument(entries: entries);
  if (loadedDocument) {
    await database.saveDocument(document);
    document = (await database.document(_documentId))!.toMutable();
  }

  final stopwatch = Stopwatch()..start();

  for (var i = 0; i < _repeats; i++) {
    await database.saveDocument(document);
  }

  stopwatch.stop();

  final result = _BenchmarkResult(
    entries: entries,
    averageTimeToSave: stopwatch.elapsed ~/ _repeats,
    bytesAsJson: bytesAsJson(document.toPlainMap()),
  );

  _results.add(result);

  // ignore: avoid_print
  print(result);
}

MutableDocument _createBenchmarkDocument({required int entries}) {
  return MutableDocument.withId(_documentId, {
    for (var i = 0; i < entries; i++) 'key$i': _jsonGenerator.generateObject(),
  });
}

class _BenchmarkResult {
  final int entries;
  final Duration averageTimeToSave;
  final int bytesAsJson;

  _BenchmarkResult({
    required this.entries,
    required this.averageTimeToSave,
    required this.bytesAsJson,
  });

  @override
  String toString() {
    return 'BenchmarkResult: '
        'entries: ${entries.toString().padLeft(6)}, '
        'averageTimeToSave: ${(averageTimeToSave.inMicroseconds / 1000.0).toStringAsFixed(2).padLeft(6)}ms, '
        'bytesAsJson: ${(bytesAsJson / 1024).toStringAsFixed(2).padLeft(8)} KB';
  }
}

extension on List<_BenchmarkResult> {
  CSVData toCsv() {
    return [
      ['Entries', 'Bytes as JSON', 'Average time to save'],
      ...map(
        (result) => [
          result.entries.toString(),
          result.bytesAsJson.toString(),
          result.averageTimeToSave.inMicroseconds / 1000.0
        ],
      ),
    ];
  }
}
