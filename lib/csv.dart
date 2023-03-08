import 'dart:io';

typedef CSVData = List<List<Object?>>;

void writeCsvFile(String path, CSVData data) {
  final file = File(path);
  file.createSync(recursive: true);
  file.writeAsStringSync(formatCsv(data));
}

String formatCsv(CSVData data) => data.map((row) => row.join(',')).join('\n');
