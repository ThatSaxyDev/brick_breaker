import 'dart:async';
import 'dart:math' as math;

import 'package:brick_breaker/src/components/ball.dart';
import 'package:brick_breaker/src/components/bat.dart';
import 'package:brick_breaker/src/components/brick.dart';
import 'package:brick_breaker/src/components/play_area.dart';
import 'package:brick_breaker/src/config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PlayState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker()
      : super(
            camera: CameraComponent.withFixedResolution(
          width: gameWidth,
          height: gameHeight,
        ));

  double get width => size.x;
  double get height => size.y;
  final rand = math.Random();
  final ValueNotifier<int> score = ValueNotifier(0);

  late Bat bat;

  late PlayState _playState; // Backing field for play state

  PlayState get playState => _playState;

  set playState(PlayState playState) {
    _playState = playState;

    // Handle overlays based on the new play state
    switch (playState) {
      case PlayState.welcome:
        overlays.add(playState.name);
      case PlayState.gameOver:
        overlays.add(playState.name);
      case PlayState.won:
        // Add overlay for the current state
        overlays.add(playState.name);

      case PlayState.playing:
        // Remove overlays for other states when playing
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    //! add the play area component
    world.add(PlayArea());

    playState = PlayState.welcome;

    bat = Bat(
      size: Vector2(batWidth, batHeight), // Set bat dimensions
      cornerRadius: const Radius.circular(ballRadius / 2), // Rounded corners
      position:
          Vector2(width / 2, height * 0.95), // Position near bottom center
    );

    // debugMode = true;
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = PlayState.playing;
    score.value = 0;

    // add a Ball to the world with random horizontal velocity and upward movement
    world.add(
      Ball(
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 4), // Normalize and scale speed by screen height
        position: size / 2, // Start at the center of the screen
        radius: ballRadius, // Set ball radius
      ),
    );

    // add a Bat to the world positioned near the bottom center of the screen
    world.add(bat);

    world.addAll([
      // Loop through brick colors to create a grid of bricks
      for (var i = 0; i < brickColors.length; i++) // Iterate over brick colors
        for (var j = 1; j <= 5; j++) // Create 5 rows of bricks
          Brick(
            position: Vector2(
              // Calculate x position based on column index, brick width, and gutter
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              // Calculate y position based on row index, brick height, and gutter
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: brickColors[i], // Set color for each brick
          ),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  // Method to update the bat's position
  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Update the bat's position based on the touch position
    bat.position.x =
        (bat.position.x + info.delta.global.x).clamp(0, size.x - bat.size.x);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    // Check which key was pressed and move the Bat accordingly
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        // Move Bat left by a fixed step
        world.children.query<Bat>().first.moveBy(-batStep);

      case LogicalKeyboardKey.arrowRight:
        // Move Bat right by a fixed step
        world.children.query<Bat>().first.moveBy(batStep);

      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }
    return KeyEventResult.handled; // Indicate that the event was handled
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);
}
