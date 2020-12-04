import 'package:flutter/material.dart';
import 'dart:math' as math;

abstract class MediaSliderItemEffect {
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount);
}

typedef EffectImplementor = MediaSliderItemEffect Function();

class Effect {
  static const Effect cubeEffect = const Effect._('Cube', _createCubeEffect);
  static const Effect accordionEffect = const Effect._('Accordion', _createAccordionEffect);
  static const Effect backgroundToForegroundEffect =
  const Effect._('Background To Foreground', _createBackgroundToForegroundEffect);
  static const Effect foregroundToBackgroundEffect =
  const Effect._('Foreground To Background', _createForegroundToBackgroundEffect);
  static const Effect defaultEffect = const Effect._('Default', _createDefaultEffect);
  static const Effect depthEffect = const Effect._('Depth', _createDepthEffect);
  static const Effect flipHorizontalEffect = const Effect._('Flip Horizontal', _createFlipHorizontalEffect);
  static const Effect flipVerticalEffect = const Effect._('Flip Vertical', _createFlipVerticalEffect);
  static const Effect parallaxEffect = const Effect._('Parallax', _createParallaxEffect);
  static const Effect stackEffect = const Effect._('Stack', _createStackEffect);
  static const Effect tabletEffect = const Effect._('Tablet', _createTabletEffect);
  static const Effect rotateDownEffect = const Effect._('Rotate Down', _createRotateDownEffect);
  static const Effect rotateUpEffect = const Effect._('Rotate Up', _createRotateUpEffect);
  static const Effect zoomOutSlideEffect = const Effect._('Zoom Out', _createZoomOutSlideEffect);

  static const Iterable<Effect> values = const [
    cubeEffect,
    accordionEffect,
    backgroundToForegroundEffect,
    foregroundToBackgroundEffect,
    defaultEffect,
    depthEffect,
    flipHorizontalEffect,
    flipVerticalEffect,
    parallaxEffect,
    stackEffect,
    tabletEffect,
    rotateDownEffect,
    rotateUpEffect,
    zoomOutSlideEffect,
  ];
  final String name;

  final EffectImplementor _implementor;

  const Effect._(this.name, this._implementor);

  @override
  int get hashCode => name.hashCode ^ _implementor.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Effect && runtimeType == other.runtimeType && name == other.name && _implementor == other._implementor;

  MediaSliderItemEffect createEffect() => _implementor();

  @override
  String toString() => 'Effect{name: $name}';

  static MediaSliderItemEffect _createAccordionEffect() => AccordionEffect();
  static MediaSliderItemEffect _createBackgroundToForegroundEffect() => BackgroundToForegroundEffect();
  static MediaSliderItemEffect _createCubeEffect() => CubeEffect();
  static MediaSliderItemEffect _createDefaultEffect() => DefaultEffect();
  static MediaSliderItemEffect _createDepthEffect() => DepthEffect();
  static MediaSliderItemEffect _createFlipHorizontalEffect() => FlipHorizontalEffect();
  static MediaSliderItemEffect _createFlipVerticalEffect() => FlipVerticalEffect();
  static MediaSliderItemEffect _createForegroundToBackgroundEffect() => ForegroundToBackgroundEffect();
  static MediaSliderItemEffect _createParallaxEffect() => ParallaxEffect();
  static MediaSliderItemEffect _createRotateDownEffect() => RotateDownEffect();
  static MediaSliderItemEffect _createRotateUpEffect() => RotateUpEffect();
  static MediaSliderItemEffect _createStackEffect() => StackEffect();
  static MediaSliderItemEffect _createTabletEffect() => TabletEffect();
  static MediaSliderItemEffect _createZoomOutSlideEffect() => ZoomOutEffect();
}





class AccordionEffect implements MediaSliderItemEffect {
  final bool transformRight;
  final bool transformLeft;

  AccordionEffect({
    this.transformRight = true,
    this.transformLeft = true,
  });

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage && transformLeft) {
      return Transform(
        alignment: Alignment.centerRight,
        transform: Matrix4.identity()..rotateY(math.pi / 2 * pageDelta),
        child: page,
      );
    }
    if (index == currentPage + 1 && transformRight) {
      return Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()..rotateY(-math.pi / 2 * (1 - pageDelta)),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class BackgroundToForegroundEffect implements MediaSliderItemEffect {
  final double startScale;

  BackgroundToForegroundEffect({
    this.startScale = 0.4,
  });

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage + 1 || currentPage == itemCount - 1 && index == 0) {
      final double scale = startScale + (1 - startScale) * pageDelta;
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale, scale),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class CubeEffect implements MediaSliderItemEffect {
  final double perspectiveScale;
  final AlignmentGeometry rightPageAlignment;
  final AlignmentGeometry leftPageAlignment;
  final double rotationAngle;

  CubeEffect({
    this.perspectiveScale = 0.0014,
    this.rightPageAlignment = Alignment.centerLeft,
    this.leftPageAlignment = Alignment.centerRight,
    double rotationAngle = 90,
  }) : this.rotationAngle = math.pi / 180 * rotationAngle;

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage) {
      return Transform(
        alignment: leftPageAlignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(rotationAngle * pageDelta),
        child: page,
      );
    } else if (index == currentPage + 1) {
      return Transform(
        alignment: rightPageAlignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(-rotationAngle * (1 - pageDelta)),
        child: page,
      );
    } else if (index == 0 && currentPage == itemCount - 1) {
      return Transform(
        alignment: rightPageAlignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(-rotationAngle * (1 - pageDelta)),
        child: page,
      );
    } else {
      return Container();
    }
  }
}

class DefaultEffect implements MediaSliderItemEffect {
  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    return page;
  }
}

class DepthEffect implements MediaSliderItemEffect {
  final double startScale;

  DepthEffect({
    this.startScale = 0.4,
  });

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage) {
      final double scale = startScale + (1 - startScale) * (1 - pageDelta);
      double width = MediaQuery.of(context).size.width;
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(width * pageDelta)
          ..scale(scale, scale),
        child: Opacity(
          opacity: (1 - pageDelta),
          child: page,
        ),
      );
    } else {
      return page;
    }
  }
}

class FlipHorizontalEffect implements MediaSliderItemEffect {
  final double perspectiveScale;

  FlipHorizontalEffect({
    this.perspectiveScale = 0.002,
  });

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    final double width = MediaQuery.of(context).size.width;
    if ((index == currentPage + 1 || index == 0 && currentPage == itemCount - 1) && pageDelta > 0.5) {
      return Transform(
        alignment: Alignment.center,
        child: page,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(math.pi * (pageDelta - 1))
          ..leftTranslate(-width * (1 - pageDelta)),
      );
    } else if (index == currentPage && pageDelta <= 0.5) {
      return Transform(
        alignment: Alignment.center,
        child: page,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateY(math.pi * pageDelta)
          ..leftTranslate(width * pageDelta),
      );
    } else {
      return Container();
    }
  }
}

class FlipVerticalEffect implements MediaSliderItemEffect {
  final double perspectiveScale;

  FlipVerticalEffect({
    this.perspectiveScale = 0.002,
  });

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    final double width = MediaQuery.of(context).size.width;
    if ((index == currentPage + 1 || index == 0 && currentPage == itemCount - 1) && pageDelta > 0.5) {
      return Transform(
        alignment: Alignment.center,
        child: page,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateX(math.pi * (pageDelta - 1))
          ..leftTranslate(-width * (1 - pageDelta)),
      );
    } else if (index == currentPage && pageDelta <= 0.5) {
      return Transform(
        alignment: Alignment.center,
        child: page,
        transform: Matrix4.identity()
          ..setEntry(3, 2, perspectiveScale)
          ..rotateX(math.pi * pageDelta)
          ..leftTranslate(width * pageDelta),
      );
    } else {
      return Container();
    }
  }
}

class ForegroundToBackgroundEffect implements MediaSliderItemEffect {
  final double endScale;

  ForegroundToBackgroundEffect({
    this.endScale = 0.4,
  });

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage) {
      final double scale = endScale + (1 - endScale) * (1 - pageDelta);
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale, scale),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class ParallaxEffect implements MediaSliderItemEffect {
  final double clipAmount;

  const ParallaxEffect({
    this.clipAmount = 200,
  });

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage + 1 || index == 0 && currentPage == itemCount - 1) {
      return Transform.translate(
        offset: Offset(-clipAmount * (1 - pageDelta), 0),
        child: ClipRect(
          child: page,
          clipper: RectClipper(clipAmount * (1 - pageDelta)),
        ),
      );
    } else {
      return page;
    }
  }
}

class RectClipper extends CustomClipper<Rect> {
  final double leftClip;

  RectClipper(this.leftClip);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(leftClip, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class RotateDownEffect implements MediaSliderItemEffect {
  final double rotationAngle;

  RotateDownEffect({
    double rotationAngle = 45,
  }) : this.rotationAngle = math.pi / 180 * rotationAngle;

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage) {
      return Transform(
        alignment: Alignment.bottomCenter,
        child: page,
        transform: Matrix4.identity()..rotateZ(-rotationAngle * pageDelta),
      );
    } else if (index == currentPage + 1 || index == 0 && currentPage == itemCount - 1) {
      return Transform(
        alignment: Alignment.bottomCenter,
        child: page,
        transform: Matrix4.identity()..rotateZ(rotationAngle * (1 - pageDelta)),
      );
    } else {
      return Container();
    }
  }
}

class RotateUpEffect implements MediaSliderItemEffect {
  final double rotationAngle;

  RotateUpEffect({
    double rotationAngle = 45,
  }) : this.rotationAngle = math.pi / 180 * rotationAngle;

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage) {
      return Transform(
        alignment: Alignment.topCenter,
        child: page,
        transform: Matrix4.identity()..rotateZ(rotationAngle * pageDelta),
      );
    } else if (index == currentPage + 1 || index == 0 && currentPage == itemCount - 1) {
      return Transform(
        alignment: Alignment.topCenter,
        child: page,
        transform: Matrix4.identity()..rotateZ(-rotationAngle * (1 - pageDelta)),
      );
    } else {
      return Container();
    }
  }
}

class StackEffect implements MediaSliderItemEffect {
  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage) {
      double width = MediaQuery.of(context).size.width;
      return Transform(
        transform: Matrix4.identity()..translate(width * pageDelta),
        child: page,
      );
    } else {
      return page;
    }
  }
}

class TabletEffect implements MediaSliderItemEffect {
  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage) {
      return Transform(
        alignment: Alignment.center,
        child: page,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(-math.pi / 4 * pageDelta),
      );
    } else if (index == currentPage + 1 || index == 0 && currentPage == itemCount - 1) {
      return Transform(
        alignment: Alignment.center,
        child: page,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(math.pi / 4 * (1 - pageDelta)),
      );
    } else {
      return Container();
    }
  }
}

class ZoomOutEffect implements MediaSliderItemEffect {
  final double zoomOutScale;
  final bool enableOpacity;

  ZoomOutEffect({
    this.zoomOutScale = 0.8,
    this.enableOpacity = true,
  });

  @override
  Widget transform(BuildContext context, Widget page, int index, int currentPage, double pageDelta, int itemCount) {
    if (index == currentPage) {
      double scale = 1 - pageDelta < zoomOutScale ? zoomOutScale : zoomOutScale + ((1 - pageDelta) - zoomOutScale);
      return Transform(
        alignment: Alignment.center,
        child: enableOpacity ? Opacity(opacity: scale, child: page) : page,
        transform: Matrix4.identity()..scale(scale, scale),
      );
    } else if (index == currentPage + 1 || index == 0 && currentPage == itemCount - 1) {
      double scale = pageDelta < zoomOutScale ? zoomOutScale : zoomOutScale + (pageDelta - zoomOutScale);
      return Transform(
        alignment: Alignment.center,
        child: enableOpacity ? Opacity(opacity: scale, child: page) : page,
        transform: Matrix4.identity()..scale(scale, scale),
      );
    } else {
      return Container();
    }
  }
}
