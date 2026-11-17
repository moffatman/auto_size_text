import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Only Text', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText('Some Text'),
    );
  });

  testWidgets('Only text (rich)', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText.rich(TextSpan(text: 'Some Text')),
    );
  });

  testWidgets('Uses style fontSize', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 34,
      widget: AutoSizeText(
        'Some Text',
        style: TextStyle(fontSize: 34),
      ),
    );
  });

  testWidgets('Uses style fontSize (rich)', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 35,
      widget: AutoSizeText.rich(
        TextSpan(text: 'Some Text'),
        style: TextStyle(fontSize: 35),
      ),
    );
  });

  testWidgets('Respects inherit style', (tester) async {
    final defaultStyle = TextStyle(
      fontSize: 20,
      color: Colors.yellow,
    );
    await pump(
      tester: tester,
      widget: DefaultTextStyle(
        style: defaultStyle,
        textAlign: TextAlign.right,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        maxLines: 17,
        child: AutoSizeText(
          'AutoSizeText Test',
        ),
      ),
    );
    final paragraph = getRenderParagraph(tester);
    expect((paragraph.text as TextSpan).style, defaultStyle);
    expect(paragraph.textAlign, TextAlign.right);
    expect(paragraph.softWrap, false);
    expect(paragraph.overflow, TextOverflow.ellipsis);
    expect(paragraph.maxLines, 17);
  });

  testWidgets('Applies scale even if initial fontSize fits (#25)',
      (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 60,
      widget: AutoSizeText(
        'Some Text',
        style: TextStyle(fontSize: 15),
        textScaleFactor: 4,
      ),
    );
  });

  testWidgets('Uses textKey', (tester) async {
    final textKey = GlobalKey();
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'A text with key',
        textKey: textKey,
      ),
    );
    expect(find.byKey(textKey), findsOneWidget);
  });

  testWidgets('Supports intrinsic measurement without LayoutBuilder',
      (tester) async {
    await pump(
      tester: tester,
      widget: const SizedBox(
        height: 30,
        child: IntrinsicWidth(
          child: AutoSizeText(
            'Intrinsic text',
            style: TextStyle(fontSize: 20),
            maxLines: 1,
          ),
        ),
      ),
    );

    expect(find.byType(LayoutBuilder), findsNothing);
    final renderBox =
        tester.renderObject<RenderBox>(find.byType(AutoSizeText));
    expect(renderBox.getMaxIntrinsicWidth(30), greaterThan(0));
  });
}
