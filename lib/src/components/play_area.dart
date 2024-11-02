import 'dart:async';

import 'package:brick_breaker/src/brick_breaker.dart';
import 'package:brick_breaker/src/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayArea extends RectangleComponent with HasGameReference<BrickBreaker> {
  PlayArea()
      : super(
          paint: Paint()..color = backGroundColor,
          children: [RectangleHitbox()],
        );
  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    size = Vector2(gameWidth, gameHeight);
  }
}
