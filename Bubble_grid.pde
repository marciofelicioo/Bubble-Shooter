  class BubbleGrid implements WallObserver {
    int rows = 15;
    int cols = 15;
    BubbleCell[][] grid;
    Wall wall;
    boolean falling = true;
    BubbleGrid(Wall wall) {
      this.wall = wall;
      this.wall.addObserver(this);
      initializeGrid();
    }
  
  void initializeGrid() {
    grid = new BubbleCell[rows][cols];
    updateCellPositions();
  }
  
    
    @Override
    void onWallHeightChanged() {
      updateCellPositions();
    }
    
void updateCellPositions() 
{
  float wallHeight = wall.getHeight();
  for (int i = 0; i < rows; i++) 
  {
      for (int j = 0; j < cols; j++) 
      {
        float x = 35.7 + j * BubbleCell.size + (i % 2 == 0 ? 0 : BubbleCell.size / 2);
        float y = 35.7 + i * BubbleCell.size * cos(radians(30)) + wallHeight;
        if (grid[i][j] == null) 
        {
          grid[i][j] = new BubbleCell(x, y, i, j);
        } 
        else 
        {
          grid[i][j].x = x;
          grid[i][j].y = y;
          if(grid[i][j].bubble != null)
          {
            grid[i][j].bubble.x_bubble = x;
            grid[i][j].bubble.y_bubble = y;
          }
        }
      }
  }
}
  ArrayList<BubbleCell> getNonEmptyNeighbours(BubbleCell cell) {
      ArrayList<BubbleCell> neighbours = new ArrayList<BubbleCell>();
      
    int[] dxOdd = {0 ,  1, 1, 0,  1, -1}; 
    int[] dyOdd = {-1, -1, 0, 1,  1, 0};
  
    int[] dxEven = {0 , 1, 0, -1, -1, -1}; 
    int[] dyEven = {-1, 0, 1,  1,  0, -1};
      
      int[] dx, dy;
      
      if (cell.row % 2 == 0) {
          dx = dxEven;
          dy = dyEven;
      } else {
          dx = dxOdd;
          dy = dyOdd;
      }
  
     for (int i = 0; i < 6; i++) {
      int newCol = cell.col + dx[i];
      int newRow = cell.row + dy[i];
  
      if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && grid[newRow][newCol] != null && grid[newRow][newCol].bubble != null) 
      {
          neighbours.add(grid[newRow][newCol]);
      }
    }
  
      return neighbours;
  }
  
  ArrayList<BubbleCell> getConnectedCells(BubbleCell start) {
      ArrayList<BubbleCell> connected = new ArrayList<BubbleCell>();
      ArrayList<BubbleCell> queue = new ArrayList<BubbleCell>();
      queue.add(start);
  
      while (!queue.isEmpty()) {
          BubbleCell cell = queue.get(0);
          queue.remove(0);
          connected.add(cell);
          ArrayList<BubbleCell> neighbours = getNonEmptyNeighbours(cell);
          for (BubbleCell neighbour : neighbours) {
              if (!connected.contains(neighbour) && !queue.contains(neighbour) && neighbour.bubble.colors == start.bubble.colors) {
                  queue.add(neighbour);
              }
          }
      }
  
      return connected;
  }
ArrayList<BubbleCell> getConnectedCellsforRemoval(BubbleCell start) {
    ArrayList<BubbleCell> connected = new ArrayList<BubbleCell>();
    ArrayList<BubbleCell> queue = new ArrayList<BubbleCell>();
    queue.add(start);

    while (!queue.isEmpty()) {
        BubbleCell cell = queue.remove(0);
        connected.add(cell);
        ArrayList<BubbleCell> neighbours = getNonEmptyNeighbours(cell);
        for (BubbleCell neighbour : neighbours) {
            if (!connected.contains(neighbour) && !queue.contains(neighbour)) {
                queue.add(neighbour);
            }
        }
    }

    return connected;
}


void markConnectedCells() {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] != null && grid[i][j].bubble != null) {
                grid[i][j].connected = false;
            }
        }
    }

    ArrayList<BubbleCell> open = new ArrayList<BubbleCell>();
    for(int j = 0; j < cols; j++) {
        if(grid[0][j] != null && grid[0][j].bubble != null) {
            open.add(grid[0][j]);
        }
    }

    while(!open.isEmpty()) {
        BubbleCell cell = open.remove(open.size() - 1); 
        cell.connected = true;
        ArrayList<BubbleCell> neighbours = getNonEmptyNeighbours(cell);
        for (BubbleCell neighbour : neighbours) {
            if (!neighbour.connected && !open.contains(neighbour)) {
                open.add(neighbour);
            }
        }
    }    
}


void freeUnconnectedBubbles() {
    markConnectedCells();
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            BubbleCell cell = grid[i][j];
            if (cell != null && cell.bubble != null && !cell.connected) {
                cell.bubble.setFalling(true);
                cell.bubble = null;
                dropped++;
            }
        }
    }
}


  
  
ArrayList<BubbleCell> getCellsWithSameColor(BubbleCell initial) 
{
    ArrayList<BubbleCell> closed = new ArrayList<>();
    ArrayList<BubbleCell> open = new ArrayList<>();
    open.add(initial);
    while (!open.isEmpty()) 
    {
        BubbleCell bc = open.remove(0);
        closed.add(bc);
        for (BubbleCell n : getNonEmptyNeighbours(bc)) 
        {
            if (n.bubble != null && initial.bubble != null && n.bubble.colors == initial.bubble.colors && !closed.contains(n) && !open.contains(n)) 
            {
                open.add(n);
            }
        }
    }
    //println("Found " + closed.size() + " cells with the same color");
    return closed;
}
  
void removeCluster()
{
  markConnectedCells();
  freeUnconnectedBubbles();
}

void increaseScoreForPoppedBubbles(int n) 
{
  int pointsPerBubble = 25 * (int)pow(2, n-4);
  score += n * pointsPerBubble;
}

void increaseScoreForDroppedBubbles(int m) 
{
  int pointsPerBubble = 10 * (int)pow(2, m-1);
  score += m * pointsPerBubble;
}
  boolean placeBubble(Bubble bubble) 
  {
      BubbleCell cell = getClosestCell(bubble);
      bubble.x_bubble = cell.x;
      bubble.y_bubble = cell.y;
      bubble.speed_x = 0;
      bubble.speed_y = 0;
      cell.bubble = bubble;
      ArrayList<BubbleCell> sameColorCells = getCellsWithSameColor(cell);
      if (sameColorCells.size() >= 4) 
      {
          for (BubbleCell c : sameColorCells)
          {
              //println("Removing bubble at row " + c.row + ", col " + c.col);
              c.bubble.needToRemove = true;
              c.bubble = null; 
              c.connected = false;
              increaseScoreForPoppedBubbles(4);
          }
          removeCluster();
          increaseScoreForDroppedBubbles(dropped); 
          return true; 
      }
      return false; 
  }
  
BubbleCell getClosestCell(Bubble bubble) 
{
  BubbleCell closestCell = null;
  float closestDistance = Float.MAX_VALUE;
  for (int i = 0; i < rows; i++) 
  {
      for (int j = 0; j < (i%2 == 0 ? cols : cols - 1); j++) 
      {
        BubbleCell cell = grid[i][j];
        float dx = cell.x - bubble.x_bubble;
        float dy = cell.y - bubble.y_bubble;
        float distance = sqrt(dx * dx + dy * dy);
        if (distance < closestDistance && cell.bubble == null) 
        {
          closestDistance = distance;
          closestCell = cell;
        }
      }
}
       return closestCell;
}
void draw() 
{
  for (int i = 0; i < rows; i++) 
  {
      for (int j = 0; j < cols; j++) 
      {
        if (grid[i][j] != null) 
        {
          grid[i][j].draw();
        }
      }
  }
}
IntList getUniqueColorsOnGrid() 
{
    IntList uniqueColors = new IntList();
    for (int i = 0; i < rows; i++) 
    {
        for (int j = 0; j < cols; j++) 
        {
            BubbleCell cell = grid[i][j];
            if (cell != null && cell.bubble != null) 
            {
                if (!uniqueColors.hasValue(cell.bubble.colors)) 
                {
                    uniqueColors.append(cell.bubble.colors);
                }
            }
        }
    }
    return uniqueColors;
}

void clear_bubbleGrid()
{
  for (int i = 0; i < rows; i++) 
  {
      for (int j = 0; j < cols; j++) 
      {
        if (grid[i][j].bubble != null) 
        {
          grid[i][j].bubble = null;
        }
      }
  }
}
boolean isEmpty() {
  boolean emptyness = true; 
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (grid[i][j].bubble != null) {
        emptyness = false;
        break;
      }
    }
    if (!emptyness) {
      break;
    }
  }
  return emptyness;
}

boolean hasBubbleTouchingLine() {
  boolean bubbleTouchingLine = false; 
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (grid[i][j] != null && grid[i][j].bubble != null && grid[i][j].bubble.y_bubble + 15.35 >= 592) {
        bubbleTouchingLine = true;
        break;
      }
    }
    if (bubbleTouchingLine) {
      break;
    }
  }
  return bubbleTouchingLine;
}

  }
