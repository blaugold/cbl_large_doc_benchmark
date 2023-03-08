import 'dart:math';

const _defaultPropertyNames = [
  'firstName',
  'lastName',
  'age',
  'address',
  'city',
  'state',
  'zip',
  'phone',
  'email',
  'company',
  'count',
  'coins',
  'price',
  'premium',
  'active',
  'userId',
  'challenge',
  'score',
  'rank',
  'level',
  'experience',
  'health',
  'mana',
  'stamina',
  'images',
  'videos',
  'documents',
  'files',
  'difficulty',
  'jokers',
  'lives',
  'step',
  'age',
  'date',
  'start',
  'endDate',
  'month',
  'event',
  'name',
  'title',
  'description',
  'text',
  'content',
  'data',
];

class JsonGenerator {
  final Random _random;
  final List<String> _propertyNames;

  JsonGenerator({
    Random? random,
    List<String>? propertyNames,
  })  : _random = random ?? Random(0),
        _propertyNames = propertyNames ?? _defaultPropertyNames;

  Object? generateValue({int depth = 0}) {
    switch (_random.nextInt(depth >= 3 ? 5 : 7)) {
      case 0:
        return null;
      case 1:
        return generateInteger();
      case 2:
        return generateFloat();
      case 3:
        return generateBool();
      case 4:
        return generateString();
      case 5:
        return generateObject(depth: depth);
      case 6:
        return generateArray(depth: depth);
    }

    throw StateError('Should not happen.');
  }

  int generateInteger() => _random.nextInt(2 ^ 32);

  double generateFloat() => _random.nextDouble();

  bool generateBool() => _random.nextBool();

  String generateString() => String.fromCharCodes(
        List.generate(_random.nextInt(20), (_) => _random.nextInt(26) + 97),
      );

  Map<String, Object?> generateObject({int depth = 0}) {
    return Map.fromEntries(
      List.generate(
        _random.nextInt(_propertyNames.length),
        (index) => MapEntry(
          _propertyNames.randomElement(_random),
          generateValue(depth: depth + 1),
        ),
      ),
    );
  }

  List<Object?> generateArray({int depth = 0}) => List.generate(
        _random.nextInt(10),
        (_) => generateValue(depth: depth + 1),
      );
}

extension _RandomListExt<T> on List<T> {
  T randomElement(Random random) => this[random.nextInt(length)];
}
