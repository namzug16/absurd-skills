// Copy to bin/generate_lucide.dart and run from the application's root.
// Generator-only dependencies: args, archive, http, path, xml.
// Supply --version <release> --framework <htmleez|jaspr>; neither is defaulted.
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('version', help: 'Explicit Lucide release tag (required).')
    ..addOption(
      'framework',
      allowed: ['htmleez', 'jaspr'],
      help: 'Generate only this framework (required).',
    )
    ..addOption('output', defaultsTo: p.join('lib', 'src', 'ui', 'lucide.dart'))
    ..addFlag('help', abbr: 'h', negatable: false);

  late final ArgResults options;
  try {
    options = parser.parse(arguments);
    if (options.flag('help')) {
      stdout.writeln(parser.usage);
      return;
    }
    if (options.rest.isNotEmpty) {
      throw FormatException('Unexpected arguments: ${options.rest.join(' ')}');
    }
    final version = options.option('version');
    if (version == null ||
        !RegExp(r'^\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?$').hasMatch(version)) {
      throw const FormatException(
        'Supply --version with an explicit Lucide release tag.',
      );
    }
    if (options.option('framework') == null) {
      throw const FormatException('Supply --framework htmleez or jaspr.');
    }
  } on FormatException catch (error) {
    stderr
      ..writeln(error.message)
      ..writeln(parser.usage);
    exitCode = 64;
    return;
  }
  final version = options.option('version')!;
  final framework = options.option('framework')!;
  final client = http.Client();
  try {
    final url = Uri.parse(
      'https://github.com/lucide-icons/lucide/releases/download/'
      '$version/lucide-icons-$version.zip',
    );
    stderr.writeln('Downloading Lucide $version...');
    final response = await client.get(url).timeout(const Duration(minutes: 2));
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('HTTP ${response.statusCode}', uri: url);
    }

    final archive = ZipDecoder().decodeBytes(response.bodyBytes);
    final icons = <String, XmlElement>{};
    for (final file in archive.files) {
      if (!file.isFile || p.posix.extension(file.name) != '.svg') continue;
      final name = _methodName(p.posix.basenameWithoutExtension(file.name));
      final root = XmlDocument.parse(utf8.decode(file.content)).rootElement;
      if (root.name.local != 'svg' || root.childElements.isEmpty) {
        throw FormatException('Invalid icon: ${file.name}');
      }
      if (icons.containsKey(name)) {
        throw FormatException('Duplicate Dart icon name: $name (${file.name})');
      }
      icons[name] = root;
    }
    if (icons.isEmpty) throw const FormatException('No SVG icons in release.');

    // Build the complete source before touching the existing output.
    final source = _buildOutput(icons, framework, version);
    final output = File(options.option('output')!);
    await output.parent.create(recursive: true);
    await output.writeAsString(source);
    stdout.writeln(
      'Generated ${output.path}: ${icons.length} $framework icons',
    );
  } catch (error) {
    stderr.writeln('Lucide generation failed: $error');
    exitCode = 1;
  } finally {
    client.close();
  }
}

String _methodName(String filename) {
  if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(filename)) {
    throw FormatException('Unsupported icon filename: $filename');
  }
  final parts = filename.split('-');
  final name =
      parts.first +
      parts
          .skip(1)
          .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
          .join();
  if (RegExp(r'^\d').hasMatch(name) || _reserved.contains(name)) {
    return 'icon${name[0].toUpperCase()}${name.substring(1)}';
  }
  return name;
}

// Includes Dart keywords and names conflicting with this generated class.
const _reserved = {
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'augment',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'Function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'type',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
  'hashCode',
  'runtimeType',
  'noSuchMethod',
  'toString',
  'Lucide',
};

// JSON escapes quotes, newlines and backslashes; also escape Dart interpolation.
String _literal(String value) => jsonEncode(value).replaceAll(r'$', r'\$');

const _svgDefaults = {
  'xmlns': 'http://www.w3.org/2000/svg',
  'width': '24',
  'height': '24',
  'viewBox': '0 0 24 24',
  'fill': 'none',
  'stroke': 'currentColor',
  'stroke-width': '2',
  'stroke-linecap': 'round',
  'stroke-linejoin': 'round',
};

String _buildOutput(
  Map<String, XmlElement> icons,
  String framework,
  String version,
) {
  final jaspr = framework == 'jaspr';
  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln('// Lucide $version; generated by bin/generate_lucide.dart')
    ..writeln('// Source: https://github.com/lucide-icons/lucide (ISC license)')
    ..writeln('// dart format off')
    ..writeln('// ignore_for_file: type=lint')
    ..writeln()
    ..writeln(
      "import 'package:${jaspr ? 'jaspr/jaspr' : 'htmleez/htmleez'}.dart';",
    )
    ..writeln()
    ..writeln('class Lucide {');

  if (jaspr) {
    buffer
      ..writeln(
        '  static Component _svg(List<Component> children, String? classes, Map<String, String> attributes) => Component.element(',
      )
      ..writeln("    tag: 'svg', classes: classes, attributes: {");
    for (final entry in _svgDefaults.entries) {
      buffer.writeln('      ${_literal(entry.key)}: ${_literal(entry.value)},');
    }
    buffer
      ..writeln('      ...attributes,')
      ..writeln('    }, children: children,')
      ..writeln('  );');
  } else {
    buffer.writeln(
      '  static HTML _svg(List<HTML> extraContent, String paths) => svg([',
    );
    for (final entry in _svgDefaults.entries) {
      buffer.writeln(
        '    \$(${_literal(entry.key)})(${_literal(entry.value)}),',
      );
    }
    buffer
      ..writeln('    ...extraContent,')
      ..writeln('    Raw(paths),')
      ..writeln('  ]);');
  }

  for (final name in icons.keys.toList()..sort()) {
    final root = icons[name]!;
    buffer.writeln();
    if (jaspr) {
      final children = root.childElements.map(_jasprElement).join(', ');
      buffer.writeln(
        '  static Component $name({String? classes, Map<String, String> attributes = const {}}) => _svg([$children], classes, attributes);',
      );
    } else {
      final paths = root.children.map((node) => node.toXmlString()).join();
      buffer.writeln(
        '  static HTML $name([List<HTML> extraContent = const []]) => _svg(extraContent, ${_literal(paths)});',
      );
    }
  }
  buffer.writeln('}');
  return buffer.toString();
}

// Native Jaspr elements work in server, static and client component trees.
String _jasprElement(XmlElement element) {
  const allowed = {
    'path',
    'circle',
    'rect',
    'line',
    'polyline',
    'polygon',
    'ellipse',
    'g',
  };
  if (!allowed.contains(element.name.local)) {
    throw FormatException('Unsupported SVG element: ${element.name}');
  }
  final attributes = element.attributes
      .map(
        (attribute) =>
            '${_literal(attribute.name.toString())}: ${_literal(attribute.value)}',
      )
      .join(', ');
  final children = element.childElements.map(_jasprElement).join(', ');
  return 'Component.element(tag: ${_literal(element.name.local)}, attributes: {$attributes}, children: [$children])';
}
