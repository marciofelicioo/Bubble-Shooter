Cannon cn = new Cannon(240,600,0);
color[] cores = {color(255,0,0,200), color(0,255,0,200), color(255,127,80,200), color(75,0,130,200), color(250,250,210,200), color(115, 253, 255,200)};
ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
Snowflake[] bubbles_1 = new Snowflake[50];
BubbleGrid bubbleGrid;
Wall wall;
Background bg;
int key_1 = 0;
Boolean reload = false;
PImage img;
int added_bubbles = 0;
boolean level_charged = false;
int score = 0;
int dropped = 0;
boolean levelLoaded = false;
boolean gameOver = false;
PFont myFont;
float height_ = 0;
boolean shooted = false;
import processing.sound.*;
SoundFile song;
SoundFile song_1;
int startTime;
void setup() 
{ 
  size(500,700);
  song = new SoundFile(this, "audio.mp3");
  song.loop();
  song_1 = new SoundFile(this, "snow skiing.wav");
  myFont = createFont("Kunstler Script", 20);
  textFont(myFont);
  img = loadImage("caravel.JPEG.jpeg");
  Bubble bubble = new Bubble(242.5,650,2.0,cores[int(random(6))]);
  bubbles.add(bubble);
  Bubble bubble_1 = new Bubble(135.5,675,2.0,cores[int(random(6))]);
  bubbles.add(bubble_1);
  for (int i = 0; i < bubbles_1.length; i++) {
      float x = random(width);
      float y = random(height);
      float size = random(10, 30);
      bubbles_1[i] = new Snowflake(x, y, size);
  }
  wall = new Wall();
  bubbleGrid = new BubbleGrid(wall);
  bg = new Background(wall);
  startTime = millis();
}
void loadLevel(String filename) 
{
   if(level_charged == false)
   {
    String[] lines = loadStrings(filename);
    bubbleGrid.clear_bubbleGrid();
    height_ = 0;
    score = 0;
      for(int i = bubbles.size()-1; i >= 0; i--)
      {
          bubbles.remove(i);
      }
      for (int i = 0; i < lines.length; i++) 
      {    
        String[] numbers = split(lines[i], ' ');
        for (int j = 0; j < numbers.length; j++) 
        {
          int colorIndex = int(numbers[j]);
          if(colorIndex > 0)
          {
            float x = 35.7 + j * BubbleCell.size + (i % 2 == 0 ? 0 : BubbleCell.size / 2);
            float y = 35.7 + i * BubbleCell.size * cos(radians(30)) + height_;
            Bubble bubble_2 = new Bubble(x, y, 2.0, cores[colorIndex - 1]);
            bubbles.add(bubble_2);
            added_bubbles++;
            bubbleGrid.grid[i][j].bubble = bubble_2;
          }
        }
      }
    IntList uniqueColors = bubbleGrid.getUniqueColorsOnGrid();
    if (uniqueColors.size() > 0) 
    {
        Bubble bubble = new Bubble(242.5,650,2.0,uniqueColors.get(int(random(uniqueColors.size()))));
        bubbles.add(bubble);
        Bubble bubble_1 = new Bubble(135.5,675,2.0,uniqueColors.get(int(random(uniqueColors.size()))));
        bubbles.add(bubble_1);
    }
   }
   level_charged = true;
   levelLoaded = true;
}

void keyPressed() 
{
  if (key >= '1' && key <= '4') 
  {
    level_charged = false;
    gameOver = false;
  }
  else if (key == ' ' && !bubbleGrid.isEmpty()) 
  {
    boolean isAnyBubbleMoving = false;
    for (Bubble b : bubbles) 
    {
        if (b.moving) 
        {
            isAnyBubbleMoving = true;
            break;
        }
    }

    if (!isAnyBubbleMoving && bubbles.isEmpty() || bubbles.size() - (added_bubbles + 1) < 0 || !bubbles.get(bubbles.size() - (added_bubbles + 1)).moving && this.reload == false) 
    {
      if (levelLoaded) 
      {
        IntList uniqueColors = bubbleGrid.getUniqueColorsOnGrid();
        Bubble newBubble = new Bubble(135.5, 675, 2.0, uniqueColors.get(int(random(uniqueColors.size()))));
        bubbles.add(newBubble);
      } 
      else 
      {
        Bubble newBubble = new Bubble(135.5, 675, 2.0, cores[int(random(6))]);
        bubbles.add(newBubble);
      }
      this.reload = true;
      println(bubbles.size());
    }
  }
}

boolean bubblesTouchingLine()
{
 for(int i = 0; i < bubbles.size(); i++)
 {
   if(bubbles.get(i).y_bubble + 15.35 == 592)
   {
     return true;
   }
 }
 return false;
}


  
void draw()
{
  if(!gameOver)
  {
  image(img,0,0);
  img.resize(500,700);
  image(img,0,0);
  bg.display();
  bubbleGrid.updateCellPositions();
  //bubbleGrid.draw();
    textFont(createFont("Arial", 20));
    textSize(20);
    fill(101, 67, 33);
    text("Level : " + key_1, 20 , 0 + height_);
  for (int i = 0; i < bubbles_1.length; i++) 
  {
    bubbles_1[i].move();
    bubbles_1[i].display();  
  }
     if (key >= '1' && key <= '4')
     {
      if (!level_charged) 
      {
          wall.height_ = 0;
          bubbleGrid.updateCellPositions();
      }
      key_1 = key - 48;
      loadLevel("level" + key + ".lvl.txt");
      int x = bubbles.size() - (added_bubbles + 3) < 0 ? 0 : bubbles.size() - (added_bubbles + 3);
      cn.display(bubbles.get(x));
      for(int i = bubbles.size()-1; i >= 0; i--)
      {
        Bubble bubble = bubbles.get(i);
        if (bubble.needToRemove) 
        {
            bubbles.remove(i);
        }
        bubble.display();
      }
       }
       else
       {
          int x = bubbles.size() - 3 < 0 ? 0 : bubbles.size() - 3;
          if(bubbles.size() > x) 
          {
            cn.display(bubbles.get(x));
              if (bubbles.get(x).shoot_bubble()) {
                song_1.play();
                startTime = millis();
                if (millis() - startTime >= 600)
                {
                    song_1.stop();
                }
              }
            if(this.reload == true && shooted == true && bubbles.get(x).moving == false) 
            {
              bubbles.get(x+1).reloading();
              if(bubbles.get(x + 1).x_bubble == 242.5) 
              {
                this.reload = false;
                shooted = false;
              }
            }
          }
          for(int i = bubbles.size()-1; i >= 0; i--)
          {
            Bubble bubble = bubbles.get(i);
            if (bubble.needToRemove) 
            {
                bubbles.remove(i);
            }
            bubble.display();
          }
        }
       println(bubbles.size());
       if(level_charged == true)
       {
         if (bubbleGrid.isEmpty()) 
         {
              textSize(100);
              fill(0, 255, 0, 120); 
              text("Victory!", 100, height - 100);
              gameOver = true;
          } 
          else if (bubbleGrid.hasBubbleTouchingLine()) 
          {
              textSize(80);
              fill(255, 0, 0, 120); 
              text("Game Over!", 40, height - 100);
              wall.height_ = 2500;
              gameOver = true; 
          }
       }
       else
       {
          if (bubbleGrid.hasBubbleTouchingLine()) 
          {
              textSize(80);
              fill(255, 0, 0, 120); 
              text("Game Over!", 40, height - 100);
              gameOver = true; 
          }
       }
  }

  textFont(createFont("Arial", 20));
  textSize(20);
  fill(101, 67, 33);
  text("Score: " + score, 300 , 0 + height_);
  
  myFont = createFont("Kunstler Script", 100);
  textFont(myFont);
  textSize(150);
  fill(101, 67, 33); 
  text("Ualg bubble", -42, -120 + height_);
  
  textFont(createFont("Arial", 20));
  textSize(20);
  fill(101, 67, 33); 
  text("Version X", 200, -100 + height_);
  
  //textFont(createFont("Arial", 20));
  //textSize(20);
  //fill(101, 67, 33); 
  //text("Thinks u are the best!", 150, -300 + height_);
}
void stop()
{
  song.stop();
  song_1.stop();
  super.stop();
}


 //<>//

  
