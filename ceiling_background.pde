class Background 
{
  int width_ = 460;
  int lastUpdateTime_;
  public int elapsedTime;
  Wall wall;

  Background(Wall wall) 
  {
      this.wall = wall;
  }
void display() 
{
  stroke(214, 255, 250, 80);
  rect(0,592,width,1);
  noStroke();
  //fill(214, 255, 250, 80);
  //rect(0,0,20,700);
  //rect(480,0,20,700);
  if(!gameOver)
  {
    int currentTime = millis();
    elapsedTime = currentTime - lastUpdateTime_;
    if (elapsedTime >= 20000) 
    {
      height_ += 30.7;
      wall.increaseHeight();
      lastUpdateTime_ = currentTime;
    }
  }
    noStroke();
    fill(214, 255, 250, 80);
    rect(0, 0, width, 20);
    rect(0, 20, width, height_);
    rect(120,690,30.7,10);
  }
}
