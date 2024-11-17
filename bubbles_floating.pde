class Snowflake {
  float x, y;
  float vx, vy;
  float size;
  float deltaTime;
  Snowflake(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    vx = random(-1, 1);
    vy = random(0.5, 2); 
  }
  
  void move() {
    deltaTime = 1000.0 / 60;
    x += vx * deltaTime/30;
    y += vy * deltaTime/30;
    if (x < -30 || x > width + 30) {
      vx *= -1;
    }
    if (y > height + 30) {
      y = 0; 
    }
  }
  
  void display() {
    stroke(255);
    strokeWeight(1);
    line(x, y - size/2, x, y + size/2); 
    line(x - size/2, y, x + size/2, y); 
    line(x - size/2, y - size/2, x + size/2, y + size/2); 
    line(x - size/2, y + size/2, x + size/2, y - size/2); 
  }
}
