// TODO: this is yuck

float base_x_1, base_x_2, point_x, point_y;
boolean mouse_tracking;

boolean keys[];

// Draw a koch spike in the square with vertices at each binary coordinate.
// The base_x parameters give the offset of the spike on the base, and the
// point_ parameters give the position of the pointy bit of the spike.
// The theta_ and x_ parameters give some further angles and lengths that can be
// extrapolated from the other parameters but really needn't be computed
// repeatedly.
void _koch(float base_x_1, float base_x_2, float point_x, float point_y,
           float theta_1, float theta_2, float x_1, float x_2, int depth) {
    if (depth > 0) {
        triangle(base_x_1, 0, base_x_2, 0, point_x, point_y);
        pushMatrix();
        scale(base_x_1);
        _koch(base_x_1, base_x_2, point_x, point_y, theta_1, theta_2, x_1, x_2,
              depth - 1);
        popMatrix();
        pushMatrix();
        translate(base_x_1, 0);
        rotate(theta_1);
        scale(x_1);
        _koch(base_x_1, base_x_2, point_x, point_y, theta_1, theta_2, x_1, x_2,
              depth - 1);
        popMatrix();
        pushMatrix();
        translate(point_x, point_y);
        rotate(theta_2);
        scale(x_2);
        _koch(base_x_1, base_x_2, point_x, point_y, theta_1, theta_2, x_1, x_2,
              depth - 1);
        popMatrix();
        pushMatrix();
        translate(base_x_2, 0);
        scale(1 - base_x_2);
        _koch(base_x_1, base_x_2, point_x, point_y, theta_1, theta_2, x_1, x_2,
              depth - 1);
        popMatrix();
    }
}

void koch(float base_x_1, float base_x_2, float point_x, float point_y,
          int depth) {
    _koch(base_x_1, base_x_2, point_x, point_y,
          atan2(point_y, point_x - base_x_1),
          atan2(-point_y, base_x_2 - point_x),
          dist(base_x_1, 0, point_x, point_y),
          dist(base_x_2, 0, point_x, point_y),
          depth);
}

void setup() {
    size(1000, 1000);
    noStroke();
    fill(255);
    point_x = 0.5;
    point_y = 0.3;
    base_x_1 = 0.3;
    base_x_2 = 0.7;
    mouse_tracking = false;
    keys = new boolean[255];
    for (int i = 0; i < keys.length; i++) {
        keys[i] = false;
    }
}

void keyPressed() {
    keys[keyCode] = true;
    int effective_key;
    if ('0' <= keyCode && keyCode <= '9') {
        effective_key = keyCode == '0' ? 9 : keyCode - '1';
        if (keys[SHIFT]) {
            base_x_1 = effective_key / 9f;
        } else {
            base_x_2 = effective_key / 9f;
        }
    } else if (keyCode == ' ') {
        mouseClicked();
    }
}

void keyReleased() {
    keys[keyCode] = false;
}

void draw() {
    background(0);
    scale(width, height);
    koch(base_x_1, base_x_2, point_x, point_y, 5);
}

void mouseClicked() {
    mouse_tracking = !mouse_tracking;
    mouseMoved();
}

void mouseMoved() {
    if (mouse_tracking) {
        point_x = (float)mouseX / width;
        point_y = (float)mouseY / height;
    }
}
