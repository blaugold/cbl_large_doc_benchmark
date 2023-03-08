import 'dart:convert';

String prettyJson(Object? value) =>
    const JsonEncoder.withIndent('  ').convert(value);

int bytesAsJson(Object? value) => JsonUtf8Encoder().convert(value).length;
