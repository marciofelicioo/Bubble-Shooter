class Cannon {
  double speed;
  float angle;
  float x, y; 
  boolean stopped = false;
  
  Cannon(float x, float y, double speed) 
  {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.angle = 0;
  }
  
  void display(Bubble bubble) 
  {
    stroke(0);
    fill(214, 255, 250, 80);
    pushMatrix();
    translate(this.x, this.y + 50); 
    rotate(radians(this.angle)); 
    rect(-23, -50, 50, 100, 3, 3, 76, 76); 
    popMatrix();
    if(this.angle > 60)
    {
      this.angle = this.angle - 1;
    }
    if(this.angle < -60)
    {
      this.angle = this.angle + 1;
    }
    if (this.angle <= 60 && this.angle >= -60) 
    { 
      if (keyCode == RIGHT && this.angle % 5 != 0) 
      {
        this.speed = 1;
        this.angle += this.speed;
      }
      else if (keyCode == LEFT && this.angle % 5 != 0) 
      {
        this.speed = 1;
        this.angle -= this.speed;
      }
      else if (this.stopped == true  && this.angle % 5 == 0) 
      {
        if (keyPressed && keyCode == RIGHT) 
        {
          this.speed = 1;
          this.angle += this.speed;
        }
        else if (keyPressed && keyCode == LEFT) 
        {
          this.speed = 1;
          this.angle -= this.speed;
        }
      }
      else if ((this.angle % 5 == 0 || this.angle == 0) && this.stopped == false) 
      {
        this.speed = 0;
        this.stopped = true;
      }
      bubble.setAngle(this.angle);
    }
  }
}
