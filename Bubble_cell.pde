class BubbleCell {
  static final float size = 30.7; 
  float x, y; 
  int row, col; 
  Bubble bubble; 
  Boolean connected;

  BubbleCell(float x, float y, int row, int col) {
    this.x = x;
    this.y = y;
    this.row = row;
    this.col = col;
  }
void draw() 
{
    if (bubble == null) 
    {
      noFill();
      stroke(0); 
      circle(x, y, size);
      textAlign(CENTER,CENTER);
      text("(" + this.row + "," + this.col + ")",x,y);
    } 
    else
    {
      bubble.draw();
    }
}

}
