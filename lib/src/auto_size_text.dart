part of auto_size_text;

/// Flutter widget that automatically resizes text to fit perfectly within its
/// bounds.
///
/// All size constraints as well as maxLines are taken into account. If the text
/// overflows anyway, you should check if the parent widget actually constraints
/// the size of this widget.
class AutoSizeText extends StatefulWidget {
  /// Creates a [AutoSizeText] widget.
  ///
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  const AutoSizeText(
    String this.data, {
    Key? key,
    this.textKey,
    this.style,
    this.strutStyle,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.group,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = true,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  : textSpan = null,
        super(key: key);

  /// Creates a [AutoSizeText] widget with a [TextSpan].
  const AutoSizeText.rich(
    TextSpan this.textSpan, {
    Key? key,
    this.textKey,
    this.style,
    this.strutStyle,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.group,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = true,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  : data = null,
        super(key: key);

  /// Sets the key for the widget that renders the text.
  ///
  /// This allows you to find the text renderer built by `AutoSizeText`.
  final Key? textKey;

  /// The text to display.
  ///
  /// This will be null if a [textSpan] is provided instead.
  final String? data;

  /// The text to display as a [TextSpan].
  ///
  /// This will be null if [data] is provided instead.
  final TextSpan? textSpan;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? style;

  // The default font size if none is specified.
  static const double _defaultFontSize = 14;

  /// The strut style to use. Strut style defines the strut, which sets minimum
  /// vertical layout metrics.
  ///
  /// Omitting or providing null will disable strut.
  ///
  /// Omitting or providing null for any properties of [StrutStyle] will result
  /// in default values being used. It is highly recommended to at least specify
  /// a font size.
  ///
  /// See [StrutStyle] for details.
  final StrutStyle? strutStyle;

  /// The minimum text size constraint to be used when auto-sizing text.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  final double minFontSize;

  /// The maximum text size constraint to be used when auto-sizing text.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  final double maxFontSize;

  /// The step size in which the font size is being adapted to constraints.
  ///
  /// The Text scales uniformly in a range between [minFontSize] and
  /// [maxFontSize].
  /// Each increment occurs as per the step size set in stepGranularity.
  ///
  /// Most of the time you don't want a stepGranularity below 1.0.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  final double stepGranularity;

  /// Predefines all the possible font sizes.
  ///
  /// **Important:** PresetFontSizes have to be in descending order.
  final List<double>? presetFontSizes;

  /// Synchronizes the size of multiple [AutoSizeText]s.
  ///
  /// If you want multiple [AutoSizeText]s to have the same text size, give all
  /// of them the same [AutoSizeGroup] instance. All of them will have the
  /// size of the smallest [AutoSizeText]
  final AutoSizeGroup? group;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was
  /// unlimited horizontal space.
  final bool? softWrap;

  /// Whether words which don't fit in one line should be wrapped.
  ///
  /// If false, the fontSize is lowered as far as possible until all words fit
  /// into a single line.
  final bool wrapWords;

  /// How visual overflow should be handled.
  ///
  /// Defaults to retrieving the value from the nearest [DefaultTextStyle] ancestor.
  final TextOverflow? overflow;

  /// If the text is overflowing and does not fit its bounds, this widget is
  /// displayed instead.
  final Widget? overflowReplacement;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  ///
  /// This property also affects [minFontSize], [maxFontSize] and [presetFontSizes].
  ///
  /// The value given to the constructor as textScaleFactor. If null, will
  /// use the [MediaQueryData.textScaleFactor] obtained from the ambient
  /// [MediaQuery], or 1.0 if there is no [MediaQuery] in scope.
  final double? textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be resized according
  /// to the specified bounds and if necessary truncated according to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int? maxLines;

  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text. This will overwrite any of the semantics labels applied
  /// directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// AutoSizeText(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  final String? semanticsLabel;

  @override
  _AutoSizeTextState createState() => _AutoSizeTextState();
}

class _AutoSizeTextState extends State<AutoSizeText> {
  @override
  void initState() {
    super.initState();

    widget.group?._register(this);
  }

  @override
  void didUpdateWidget(AutoSizeText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.group != widget.group) {
      oldWidget.group?._remove(this);
      widget.group?._register(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);

    var style = widget.style;
    if (widget.style == null || widget.style!.inherit) {
      style = defaultTextStyle.style.merge(widget.style);
    }
    if (style!.fontSize == null) {
      style = style.copyWith(fontSize: AutoSizeText._defaultFontSize);
    }
    if (MediaQuery.boldTextOf(context)) {
      style = style.merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final effectiveStyle = style;

    final maxLines = widget.maxLines ?? defaultTextStyle.maxLines;
    final userScale =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);

    _validateProperties(effectiveStyle, maxLines);

    if (widget.group != null || widget.overflowReplacement != null) {
      return LayoutBuilder(builder: (context, size) {
        final (fontSize, textFits) =
            _calculateFontSize(size, effectiveStyle, maxLines, userScale);

        Widget text;

        if (widget.group != null) {
          widget.group!._updateFontSize(this, fontSize);
          text = _buildText(widget.group!._fontSize, effectiveStyle, maxLines);
        } else {
          text = _buildText(fontSize, effectiveStyle, maxLines);
        }

        if (widget.overflowReplacement != null && !textFits) {
          return widget.overflowReplacement!;
        } else {
          return text;
        }
      });
    }

    final span = _buildTextSpan(effectiveStyle);
    Widget text = _AutoSizeTextLayout(
      key: widget.textKey,
      text: span,
      baseFontSize: effectiveStyle.fontSize!,
      textAlign: widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection ?? Directionality.of(context),
      locale: widget.locale ?? Localizations.maybeLocaleOf(context),
      strutStyle: widget.strutStyle,
      softWrap: widget.softWrap ?? defaultTextStyle.softWrap,
      maxLines: maxLines,
      overflow: widget.overflow ?? effectiveStyle.overflow ?? defaultTextStyle.overflow,
      textWidthBasis: defaultTextStyle.textWidthBasis,
      textHeightBehavior: defaultTextStyle.textHeightBehavior ??
          DefaultTextHeightBehavior.maybeOf(context),
      registrar: SelectionContainer.maybeOf(context),
      selectionColor: DefaultSelectionStyle.of(context).selectionColor ??
          DefaultSelectionStyle.defaultColor,
      calculateFontSize: (constraints) =>
          _calculateFontSize(constraints, effectiveStyle, maxLines, userScale).$1,
    );
    if (widget.semanticsLabel != null) {
      text = Semantics(
        label: widget.semanticsLabel,
        child: ExcludeSemantics(child: text),
      );
    }
    return text;
  }

  TextSpan _buildTextSpan(TextStyle style) {
    return TextSpan(
      style: style,
      text: widget.data,
      children:
          widget.textSpan == null ? null : <InlineSpan>[widget.textSpan!],
    );
  }

  void _validateProperties(TextStyle style, int? maxLines) {
    assert(widget.overflow == null || widget.overflowReplacement == null,
        'Either overflow or overflowReplacement must be null.');
    assert(maxLines == null || maxLines > 0,
        'MaxLines must be greater than or equal to 1.');
    assert(widget.key == null || widget.key != widget.textKey,
        'Key and textKey must not be equal.');

    if (widget.presetFontSizes == null) {
      assert(
          widget.stepGranularity >= 0.1,
          'StepGranularity must be greater than or equal to 0.1. It is not a '
          'good idea to resize the font with a higher accuracy.');
      assert(widget.minFontSize >= 0,
          'MinFontSize must be greater than or equal to 0.');
      assert(widget.maxFontSize > 0, 'MaxFontSize has to be greater than 0.');
      assert(widget.minFontSize <= widget.maxFontSize,
          'MinFontSize must be smaller or equal than maxFontSize.');
      assert(widget.minFontSize / widget.stepGranularity % 1 == 0,
          'MinFontSize must be a multiple of stepGranularity.');
      if (widget.maxFontSize != double.infinity) {
        assert(widget.maxFontSize / widget.stepGranularity % 1 == 0,
            'MaxFontSize must be a multiple of stepGranularity.');
      }
    } else {
      assert(widget.presetFontSizes!.isNotEmpty,
          'PresetFontSizes must not be empty.');
    }
  }

  (double, bool) _calculateFontSize(
      BoxConstraints size,
      TextStyle style,
      int? maxLines,
      double userScale) {
    final span = _buildTextSpan(style);

    int left;
    int right;
    int? suggestedIndex;

    final presetFontSizes = widget.presetFontSizes?.reversed.toList();
    if (presetFontSizes == null) {
      final num defaultFontSize =
          style.fontSize!.clamp(widget.minFontSize, widget.maxFontSize);
      final defaultScale = defaultFontSize * userScale / style.fontSize!;
      final (fits, guess) = _checkTextFits(span, defaultScale, maxLines, size);
      if (fits) {
        return (defaultFontSize * userScale, true);
      }

      left = (widget.minFontSize / widget.stepGranularity).floor();
      right = (defaultFontSize / widget.stepGranularity).ceil();
      if (guess != null && userScale > 0) {
        suggestedIndex = (style.fontSize! * guess /
                userScale /
                widget.stepGranularity)
            .floor()
            .clamp(left, right);
      }
    } else {
      left = 0;
      right = presetFontSizes.length - 1;
    }

    var lastValueFits = false;
    while (left <= right) {
      final currentSuggestion = suggestedIndex;
      final mid = currentSuggestion != null &&
              currentSuggestion >= left &&
              currentSuggestion <= right
          ? currentSuggestion
          : (left + (right - left) / 2).floor();
      suggestedIndex = null;
      double scale;
      if (presetFontSizes == null) {
        scale = mid * userScale * widget.stepGranularity / style.fontSize!;
      } else {
        scale = presetFontSizes[mid] * userScale / style.fontSize!;
      }
      final (fits, guess) = _checkTextFits(span, scale, maxLines, size);
      if (fits) {
        left = mid + 1;
        lastValueFits = true;
      } else {
        right = mid - 1;
        if (guess != null &&
            presetFontSizes == null &&
            userScale > 0 &&
            left <= right) {
          suggestedIndex = (style.fontSize! * guess /
                  userScale /
                  widget.stepGranularity)
              .floor()
              .clamp(left, right);
        }
      }
    }

    if (!lastValueFits) {
      right += 1;
    }

    double fontSize;
    if (presetFontSizes == null) {
      fontSize = right * userScale * widget.stepGranularity;
    } else {
      fontSize = presetFontSizes[right] * userScale;
    }

    return (fontSize, lastValueFits);
  }

  (bool, double?) _checkTextFits(
      TextSpan text, double scale, int? maxLines, BoxConstraints constraints) {
    if (!widget.wrapWords) {
      final words = text.toPlainText().split(RegExp('\\s+'));

      final wordWrapTextPainter = TextPainter(
        text: TextSpan(
          style: text.style,
          text: words.join('\n'),
        ),
        textAlign: widget.textAlign ?? TextAlign.left,
        textDirection: widget.textDirection ?? TextDirection.ltr,
        textScaleFactor: scale,
        maxLines: words.length,
        locale: widget.locale,
        strutStyle: widget.strutStyle,
      );

      wordWrapTextPainter.layout(maxWidth: constraints.maxWidth);

      if (wordWrapTextPainter.didExceedMaxLines ||
          wordWrapTextPainter.width > constraints.maxWidth) {
        return (false, null);
      }
    }

    final textPainter = TextPainter(
      text: text,
      textAlign: widget.textAlign ?? TextAlign.left,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      textScaleFactor: scale,
      maxLines: maxLines,
      ellipsis: widget.overflow == TextOverflow.ellipsis ? '\u2026' : null,
      locale: widget.locale,
      strutStyle: widget.strutStyle,
    );

    textPainter.layout(maxWidth: constraints.maxWidth);

    if (textPainter.didExceedMaxLines) {
      return (false, null);
    }

    if ((textPainter.height > constraints.maxHeight || textPainter.width > constraints.maxWidth) && textPainter.computeLineMetrics().length == 1) {
      // Only do this with single-line text
      // I guess it would also be safe with multi line (hard linebreak only)
      // But I don't use those with AutoSizeText really
      final heightFactor = constraints.maxHeight.isFinite ? textPainter.height / constraints.maxHeight : 1;
      final widthFactor = constraints.maxWidth.isFinite ? textPainter.width / constraints.maxWidth : 1;
      return (false, scale / math.max(heightFactor, widthFactor));
    }

    return (!(textPainter.height > constraints.maxHeight || textPainter.width > constraints.maxWidth), null);
  }

  Widget _buildText(double fontSize, TextStyle style, int? maxLines) {
    if (widget.data != null) {
      return Text(
        widget.data!,
        key: widget.textKey,
        style: style.copyWith(fontSize: fontSize),
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaleFactor: 1,
        maxLines: maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    } else {
      return Text.rich(
        widget.textSpan!,
        key: widget.textKey,
        style: style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaleFactor: fontSize / style.fontSize!,
        maxLines: maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    }
  }

  void _notifySync() {
    setState(() {});
  }

  @override
  void dispose() {
    if (widget.group != null) {
      widget.group!._remove(this);
    }
    super.dispose();
  }
}

typedef _FontSizeCalculator = double Function(BoxConstraints constraints);

class _AutoSizeTextLayout extends LeafRenderObjectWidget {
  const _AutoSizeTextLayout({
    super.key,
    required this.text,
    required this.baseFontSize,
    required this.textAlign,
    required this.textDirection,
    required this.locale,
    required this.strutStyle,
    required this.softWrap,
    required this.maxLines,
    required this.overflow,
    required this.textWidthBasis,
    required this.textHeightBehavior,
    required this.registrar,
    required this.selectionColor,
    required this.calculateFontSize,
  });

  final InlineSpan text;
  final double baseFontSize;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final bool softWrap;
  final int? maxLines;
  final TextOverflow overflow;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final SelectionRegistrar? registrar;
  final Color selectionColor;
  final _FontSizeCalculator calculateFontSize;

  @override
  RenderParagraph createRenderObject(BuildContext context) {
    return _RenderAutoSizeText(
      text: text,
      baseFontSize: baseFontSize,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      strutStyle: strutStyle,
      softWrap: softWrap,
      maxLines: maxLines,
      overflow: overflow,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      registrar: registrar,
      selectionColor: selectionColor,
      calculateFontSize: calculateFontSize,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderAutoSizeText renderObject) {
    renderObject
      ..text = text
      ..baseFontSize = baseFontSize
      ..textAlign = textAlign
      ..textDirection = textDirection
      ..locale = locale
      ..strutStyle = strutStyle
      ..softWrap = softWrap
      ..maxLines = maxLines
      ..overflow = overflow
      ..textWidthBasis = textWidthBasis
      ..textHeightBehavior = textHeightBehavior
      ..registrar = registrar
      ..selectionColor = selectionColor
      ..calculateFontSize = calculateFontSize;
  }
}

class _RenderAutoSizeText extends RenderParagraph {
  _RenderAutoSizeText({
    required InlineSpan text,
    required double baseFontSize,
    required TextAlign textAlign,
    required TextDirection textDirection,
    required Locale? locale,
    required StrutStyle? strutStyle,
    required bool softWrap,
    required int? maxLines,
    required TextOverflow overflow,
    required TextWidthBasis textWidthBasis,
    required TextHeightBehavior? textHeightBehavior,
    required SelectionRegistrar? registrar,
    required Color selectionColor,
    required _FontSizeCalculator calculateFontSize,
  })  : _baseFontSize = baseFontSize,
        _calculateFontSize = calculateFontSize,
        super(
          text,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          strutStyle: strutStyle,
          softWrap: softWrap,
          maxLines: maxLines,
          overflow: overflow,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          registrar: registrar,
          selectionColor: selectionColor,
        );

  double _baseFontSize;
  _FontSizeCalculator _calculateFontSize;

  set baseFontSize(double value) {
    if (_baseFontSize == value) return;
    _baseFontSize = value;
    markNeedsLayout();
  }

  set calculateFontSize(_FontSizeCalculator value) {
    _calculateFontSize = value;
    markNeedsLayout();
  }

  TextPainter _createTextPainter(double fontSize) {
    return TextPainter(
      text: text,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaler: TextScaler.linear(fontSize / _baseFontSize),
      maxLines: maxLines,
      ellipsis: overflow == TextOverflow.ellipsis ? '\u2026' : null,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  TextPainter _layoutText(BoxConstraints constraints) {
    final painter = _createTextPainter(_calculateFontSize(constraints));
    painter.layout(
      minWidth: constraints.minWidth,
      maxWidth: softWrap || overflow == TextOverflow.ellipsis
          ? constraints.maxWidth
          : double.infinity,
    );
    return painter;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final painter = _layoutText(BoxConstraints(maxHeight: height));
    return painter.minIntrinsicWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final painter = _layoutText(BoxConstraints(maxHeight: height));
    return painter.maxIntrinsicWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _layoutText(BoxConstraints(maxWidth: width)).height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _layoutText(BoxConstraints(maxWidth: width)).height;
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.constrain(_layoutText(constraints).size);
  }

  @override
  double computeDryBaseline(
      covariant BoxConstraints constraints, TextBaseline baseline) {
    return _layoutText(constraints).computeDistanceToActualBaseline(baseline);
  }

  @override
  void performLayout() {
    final fontSize = _calculateFontSize(constraints);
    textPainter.textScaler = TextScaler.linear(fontSize / _baseFontSize);
    super.performLayout();
  }
}
