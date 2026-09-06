import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/shared/widgets/section_label.dart';

void main() {
  Widget host(Widget child, {double textScale = 1.0, double width = 260}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: Center(child: SizedBox(width: width, child: child)),
        ),
      ),
    );
  }

  testWidgets('a heading and a trailing label fit side by side', (tester) async {
    await tester.pumpWidget(
      host(
        const SectionLabel('Today', trailing: Text('12 of 15 left')),
      ),
    );

    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('12 of 15 left'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('neither part overflows at the 130% text scale section 7.6 asks for',
      (tester) async {
    // Regression: the row had no flex on either child, so this pair rendered
    // the yellow-and-black overflow stripe instead of ellipsising. Caught by
    // the shared-component goldens.
    await tester.pumpWidget(
      host(
        const SectionLabel('Recent transactions', trailing: Text('12 of 15 left')),
        textScale: 1.3,
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('a long heading ellipsises rather than overflowing',
      (tester) async {
    await tester.pumpWidget(
      host(
        const SectionLabel(
          'A section heading far longer than the row it has to live in',
        ),
        width: 160,
      ),
    );

    expect(tester.takeException(), isNull);
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.maxLines, 1);
  });

  testWidgets('a very narrow row still lays out both children', (tester) async {
    await tester.pumpWidget(
      host(
        const SectionLabel('Payment history', trailing: Text('See all')),
        width: 90,
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
