import 'dart:io';

void main(List<String> arguments) async {
  // Init values
  final file = File('./assets/text.txt');
  final youtubeFile = File('./assets/youtube.txt');
  final anchorFile = File('./assets/anchor.txt');
  var youtubeLines = <String>[];
  var anchorLines = <String>[];
  var index = 0;
  const headers = <String>[
    'Noticias: ',
    'Widget: ',
    'Package: ',
    'Dica: ',
    'Fonte de conhecimento: ',
    'Bugs e debugs: '
  ];

  // Read lines and convert lines
  final lines = file.readAsLinesSync();
  lines.forEach((l) {
    var title = l.splitMapJoin(
      RegExp(r'\[[^\]]*]', caseSensitive: false),
      onMatch: (match) {
        return match.group(0)!.replaceAll('[', '').replaceAll(']', '');
      },
      onNonMatch: (nonMatch) => '',
    );
    var link = l.splitMapJoin(
      RegExp(r'\([^\)]*', caseSensitive: false),
      onMatch: (match) {
        return match.group(0)!.replaceAll('(', '').replaceAll(')', '');
      },
      onNonMatch: (nonMatch) => '',
    );
    if (index < (headers.length - 1) && l.startsWith(headers[index + 1])) {
      index++;
    }
    if (l.startsWith(headers[index])) {
      youtubeLines.add('${headers[index]}$title | $link\n');
      if (index == 0) {
        anchorLines
            .add('<p>${headers[index]}<a href="$link">$title</a></br>\n');
      } else if (index >= 5) {
        anchorLines.add('${headers[index]}<a href="$link">$title</a></p>\n');
      } else {
        anchorLines.add('${headers[index]}<a href="$link">$title</a></br>\n');
      }
    } else {
      youtubeLines.add('$title | $link\n');
      if (index == 0) {
        anchorLines.add('<a href="$link">$title</a></br>\n');
      } else if (index >= 5) {
        // If have more than 2 links, this dont work
        anchorLines[anchorLines.length - 1] =
            anchorLines[anchorLines.length - 1].replaceAll('</p>', '</br>');
        anchorLines.add('<a href="$link">$title</a></p>\n');
      } else {
        anchorLines.add('<a href="$link">$title</a></br>\n');
      }
    }
  });

  // Show parsing text
  youtubeLines.add('\nVisita https://universoflutter.com para saber mais');
  youtubeLines.add(
      '\n\nCriado e editado por Matias de Andrea (https://deandreamatias.com)');
  youtubeLines.add('\n\n#flutter #flutterDev #dart');
  final youtube = youtubeLines.join('\n').replaceAll('\n\n', '\n');
  print('YOUTUBE\n\n$youtube');
  youtubeFile.writeAsStringSync(youtube);

  final anchor = anchorLines.join('\n').replaceAll('\n\n', '\n');
  print('ANCHOR\n\n$anchor');
  anchorFile.writeAsStringSync(anchor);

  exit(0);
}
