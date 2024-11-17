class Bubble extends Cannon
{
 float angle;
 float x_bubble;
 float y_bubble;
 float speed;
 float speed_x;
 float speed_y;
 float wall_height_;
 float bubble_angle = 0;
 boolean change_direction = true;
 boolean reached_top = false;
 color colors;
 int lastUpdateTime_;
 int previous_wall_height = 0;
 boolean moving;
 boolean needToRemove = false;
 boolean falling = false;
 Bubble(float x, float y, float speed,color colors)
 {
   super(x,y,speed);
   this.x_bubble = x;
   this.y_bubble = y;
   this.speed = speed; 
   this.colors = colors;
 }
void setFalling(boolean falling) 
{
  this.falling = falling;
}
void setAngle(float angle)
{
   this.angle = angle;
}  
int get_elapsed_time() 
{
  int currentTime = millis();
  int elapsedTime = currentTime - lastUpdateTime_;
  if (elapsedTime >= 20000) 
  {
    lastUpdateTime_ = currentTime;
  }
  return elapsedTime;
}
//void draw()
//{
//   stroke(0);
//   fill(this.colors);
//   circle(this.x_bubble,this.y_bubble,30.7);
//   if(this.x_bubble + 15.35 > 230 && this.x_bubble + 15.35 < 270 && this.y_bubble > 592)
//   {
//     noStroke();
//     fill(214, 255, 250, 80);
//     circle(this.x_bubble,this.y_bubble,30.7);
//   }
//}
void draw()
{
   stroke(0);
   fill(this.colors);
   circle(this.x_bubble,this.y_bubble,30.7);
}  
void angle_fixed()
{
  if(this.angle <= 0)
  {
    bubble_angle = -(this.angle) + 90;
  }
  else if(this.angle > 0)
  {
    bubble_angle = 90 - this.angle;
  }
}
void collisions() {
  for (int i = 0; i < bubbles.size(); i++) 
  {
    Bubble bubble1 = bubbles.get(i);
    for (int j = i + 1; j < bubbles.size(); j++) 
    {
      Bubble bubble2 = bubbles.get(j);      
      float dx = bubble1.x_bubble - bubble2.x_bubble;
      float dy = bubble1.y_bubble - bubble2.y_bubble;
      double distance = 0;
      if(this.falling == false)
      {
          distance = Math.sqrt(pow(dx,2) + pow(dy,2));     
        if (distance < 35) 
        {
          distance = 31;
          if (bubble2.moving) 
          {
            bubble2.moving = false;
            bubbleGrid.placeBubble(bubble2);
          }
        }
      }
    }
  }
}


boolean shoot_bubble()
{
  angle_fixed();
  if(key == ' ' && this.y_bubble > 627 && this.moving == false && this.x_bubble >= 242.5)
  {
   this.moving  = true;
   float maxDistance = this.speed * 8; 
   float dx = maxDistance * cos(radians(this.bubble_angle));
   float dy = -maxDistance * sin(radians(this.bubble_angle));
   float distance = sqrt(pow(dx, 2) + pow(dy, 2));
   float scale = maxDistance / distance;
   this.speed_x = dx * scale;
   this.speed_y = dy * scale; 
   shooted = true;
   return true;
  }
  return false;
}
void bubble_movement() 
{
    
    if (this.moving == true && this.falling == false) 
    {  
        collisions();
        this.x_bubble += this.speed_x;
        this.y_bubble += this.speed_y;
        if (this.x_bubble >= 474 || this.x_bubble <= 35.7) 
        {
            this.speed_x *= -1;
        }
        if (this.y_bubble <= 35.7 + height_) 
        { 
            this.moving = false;
            bubbleGrid.placeBubble(this);
        }
    }
    if(this.falling == true)
    {
      this.y_bubble += 13;
      if(this.y_bubble >= 750)
      {
         this.needToRemove = true;
         this.falling = false;
      }
    }
}



void reloading() 
{
  if(this.x_bubble < 242.5)
  {
    float d_fram = 97/(frameRate * 0.5);
    this.x_bubble +=  d_fram;
    float d_fram_y = 25/(frameRate * 0.5);
    this.y_bubble -= d_fram_y;
    if(this.x_bubble > 242.5)
      this.x_bubble = 242.5;        
  }
}
void display()
{
  draw();
   bubble_movement();
   //bubble_movement();
   //println("speed_x: " + this.speed_x);
   //println("speed_y: " + this.speed_y);
   //println("Cannon angle: " + this.bubble_angle);
   //println("wall_height_: " + this.wall_height_);
   //println("y_bubble: " + this.y_bubble);
 }
}
