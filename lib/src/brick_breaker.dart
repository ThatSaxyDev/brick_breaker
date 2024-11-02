import 'dart:async';
import 'dart:math' as math;

import 'package:brick_breaker/src/components/ball.dart';
import 'package:brick_breaker/src/components/play_area.dart';
import 'package:brick_breaker/src/config.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class BrickBreaker extends FlameGame with HasCollisionDetection {
  BrickBreaker()
      : super(
            camera: CameraComponent.withFixedResolution(
          width: gameWidth,
          height: gameHeight,
        ));

  double get width => size.x;
  double get height => size.y;
  final rand = math.Random();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    //! add the play area component
    world.add(PlayArea());

    //! add the ball component
    /*
    adds a new Ball instance to the world in your game. The Ball class takes velocity, position, and radius as parameters.
    velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2):

    rand.nextDouble() generates a random value between 0 and 1.
    Subtracting 0.5 centers this value around 0, giving a range from -0.5 to +0.5.
    Multiplying by width scales this to range from -width / 2 to +width / 2.
    For the y-component, height * 0.2 gives the ball an upward (or downward) velocity based on 20% of the screen height.
    .normalized() ..scale(height / 4):

    .normalized() adjusts the vector’s length to 1 while keeping its direction, making it a unit vector.
    ..scale(height / 4) scales this unit vector to a length of height / 4. This creates a consistent speed for the ball based on the height of the screen, regardless of direction.
    position: size / 2:

    size / 2 places the ball at the center of the screen, assuming size is a Vector2 representing the screen’s width and height.
    radius: ballRadius:

    radius sets the size of the ball to ballRadius.
    */
    world.add(Ball(
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 4),
        position: size / 2,
        radius: ballRadius));
  }
}
