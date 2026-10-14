---
name: dart-data-class
description: >
  Write pragmatic Dart data classes using primary constructors and manual helpers: fromMap, toMap, copyWith, equality, hashCode, and toString. Use when creating or refactoring Dart/Flutter model classes without code generation.
metadata:
  last_modified: Fri, 25 Sep 2026 00:00:00 GMT
---

# Dart Data Class Skill

Use this skill when creating or refactoring Dart model/data classes, especially in apps that avoid code generation.

The preferred style is:

- immutable classes with `final` fields
- primary constructors when available
- `const` constructors when possible
- manual `fromMap` / `toMap` methods instead of `fromJson` / `toJson`
- manual `copyWith`, `==`, `hashCode`, and `toString`
- no `build_runner`, Freezed, JsonSerializable, Equatable, Dart Mappable or similar packages unless the project already uses them

---

## Primary data-class template

```dart
class const User(
  final String id,
  final String name,
  final String email,
  final DateTime createdAt,
) {
  factory fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'id': String id,
        'name': String name,
        'email': String email,
        'created_at': String createdAt,
      } => User(
          id,
          name,
          email,
          DateTime.parse(createdAt),
        ),
      _ => throw const FormatException('Invalid User map.'),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id ?? this.id,
      name ?? this.name,
      email ?? this.email,
      createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            other.id == id &&
            other.name == name &&
            other.email == email &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, name, email, createdAt);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, createdAt: $createdAt)';
  }
}
```

If the project is not yet using Dart primary constructors, fall back to the conventional constructor style while keeping the same helper methods:

```dart
class User {
  final String id;
  final String name;

  const User({
    required this.id,
    required this.name,
  });
}
```

---

## Core rules

### 1. Prefer immutable fields

Use `final` for data-class fields by default.

```dart
class const Place(final String id, final String name);
```

Use `var` only when mutation is truly part of the model's intended behavior.

### 2. Use `const` when possible

If every field can be initialized in a const context, prefer a const primary constructor:

```dart
class const LatLng(final double lat, final double lng);
```

### 3. Keep map keys explicit

Map external snake_case keys to Dart camelCase fields manually.

```dart
class const Profile(final String avatarUrl) {
  factory fromMap(Map<String, dynamic> map) {
    return Profile(map['avatar_url'] as String);
  }

  Map<String, dynamic> toMap() {
    return {'avatar_url': avatarUrl};
  }
}
```

### 4. Prefer `fromMap` / `toMap`, not `fromJson` / `toJson`

In Dart code, the object being passed around is usually a `Map<String, dynamic>`, even when it came from JSON, Supabase, SQLite, storage, or an HTTP response.

Use:

```dart
factory fromMap(Map<String, dynamic> map)
Map<String, dynamic> toMap()
```

Only add `fromJson` / `toJson` if an API, package, or existing project convention specifically expects those names.

### 5. Override `==` together with `hashCode`

Never override only `hashCode`. Data-class equality requires both:

```dart
@override
bool operator ==(Object other) {
  return identical(this, other) ||
      other is Place && other.id == id && other.name == name;
}

@override
int get hashCode => Object.hash(id, name);
```

For more than 20 fields, use `Object.hashAll([...])`.

### 6. Keep `toString` readable

Include the class name and useful field values.

```dart
@override
String toString() => 'Place(id: $id, name: $name)';
```

Do not include sensitive values such as tokens, passwords, or private keys.

---

## Implementing `fromMap`

Prefer pattern matching when the expected shape is strict and simple:

```dart
factory fromMap(Map<String, dynamic> map) {
  return switch (map) {
    {
      'id': String id,
      'name': String name,
      'age': int age,
    } => Person(id, name, age),
    _ => throw const FormatException('Invalid Person map.'),
  };
}
```

Use explicit casts when optional fields, defaults, or conversions make the code clearer:

```dart
factory fromMap(Map<String, dynamic> map) {
  return Person(
    map['id'] as String,
    map['name'] as String? ?? 'Unknown',
    (map['age'] as num?)?.toInt() ?? 0,
  );
}
```

Common conversions:

```dart
DateTime.parse(map['created_at'] as String)
(map['count'] as num).toInt()
(map['price'] as num).toDouble()
(map['tags'] as List<dynamic>? ?? const []).cast<String>()
```

Nested objects:

```dart
Address.fromMap(map['address'] as Map<String, dynamic>)
```

Lists of nested objects:

```dart
(map['items'] as List<dynamic>? ?? const [])
    .cast<Map<String, dynamic>>()
    .map(OrderItem.fromMap)
    .toList()
```

---

## Implementing `toMap`

Return a new `Map<String, dynamic>` with external/storage keys.

```dart
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'name': name,
    'created_at': createdAt.toIso8601String(),
    'address': address.toMap(),
    'items': items.map((item) => item.toMap()).toList(),
  };
}
```

For nullable fields, include them when the receiving API expects explicit nulls:

```dart
'deleted_at': deletedAt?.toIso8601String(),
```

Omit nullable fields only when the target API/database distinguishes omitted values from explicit nulls.

---

## Implementing `copyWith`

For non-nullable fields, standard nullable parameters are enough:

```dart
Person copyWith({String? name, int? age}) {
  return Person(name ?? this.name, age ?? this.age);
}
```

For nullable fields where callers must be able to set the value to `null`, use a private sentinel:

```dart
const _unset = Object();

class const Task(final String id, final DateTime? completedAt) {
  Task copyWith({String? id, Object? completedAt = _unset}) {
    return Task(
      id ?? this.id,
      identical(completedAt, _unset) ? this.completedAt : completedAt as DateTime?,
    );
  }
}
```

Use the sentinel pattern only when needed. For most simple models, keep `copyWith` simple.

---

## Collections and equality

Dart `List`, `Map`, and `Set` compare by identity by default. If a data class contains collections and value equality matters, use Flutter's built-in `listEquals`, `mapEquals`, or `setEquals` from `package:flutter/foundation.dart`.

```dart
import 'package:flutter/foundation.dart';

class const Palette(final List<String> colors) {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Palette && listEquals(other.colors, colors);
  }

  @override
  int get hashCode => Object.hashAll(colors);
}
```

If this is pure Dart, avoid adding dependencies just for deep equality unless the project already has one. Keep the model simple or document identity equality for collections.

---

## Checklist

When creating a data class, implement:

- [ ] primary constructor with `final` fields
- [ ] `const` constructor when possible
- [ ] `factory fromMap(Map<String, dynamic> map)`
- [ ] `Map<String, dynamic> toMap()`
- [ ] `copyWith(...)`
- [ ] `operator ==`
- [ ] `hashCode`
- [ ] `toString()`
- [ ] tests or at least analyzer validation for map parsing edge cases

---

## Project style notes

- Put model/data classes in the project's model directory, for example `lib/src/core/models`.
- Keep classes plain and navigable.
- Do not introduce repositories, adapters, base model classes, or serialization abstractions unless they remove real duplication.
- Prefer direct, explicit mapping code over clever generic mappers.
- Keep naming aligned with existing project conventions.
