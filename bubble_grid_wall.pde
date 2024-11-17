interface WallObserver {
  void onWallHeightChanged();
}

class Wall {
  float height_;
  private ArrayList<WallObserver> observers = new ArrayList<>();
  
  void addObserver(WallObserver observer) {
    observers.add(observer);
  }
  
 void increaseHeight() {
    height_ += 30.7;
    for (WallObserver observer : observers) {
        if (observer != null) {
            observer.onWallHeightChanged();
        } else {
            println("Found a null observer!");
        }
    }
}
  
  float getHeight() {
    return height_;
  }
}
