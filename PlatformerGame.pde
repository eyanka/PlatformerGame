//Platformer Game

final static float MOVE_SPEED = 4; 
final static float SPRITE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50;
final static float COIN_SCALE = 0.4;
final static float GRAVITY = .6;
final static float JUMP_SPEED = 10; 
final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

//declare global variables
Sprite s1;
PImage crate, coin, red_brick, brown_brick, tile, snow;
ArrayList<Sprite> platforms;
//Sprite player;
ArrayList<Sprite> coins; 
int score;
float view_x = 0;
float view_y = 0;

//initialize them in setup().
void setup(){
  size(800, 600); 
  imageMode(CENTER); 
  s1 = new Sprite("player.png", 1.0, 400, 200);
  s1.change_x = 0;
  s1.change_y = 0;
  platforms = new ArrayList<Sprite>();
  crate = loadImage("crate.png");
  coin = loadImage("coin.png");
  red_brick = loadImage("red_brick.png");
  brown_brick = loadImage("brown_brick.png");
  tile = loadImage("tile.png");
  snow = loadImage("snow.png");
  createPlatforms("map.csv");
  
  score = 0;
  coins = new ArrayList<Sprite>();
  for(int i = 0; i < 10; i++){
    Sprite coin = new Sprite("coin.png", COIN_SCALE);
    coin.center_x = (float)(Math.random()*width);
    coin.center_y = (float)(Math.random()*height);
    coins.add(coin);
  }  
}

// modify and update them in draw().
void draw(){
  background(255);
  scroll();
  s1.display();
  s1.update();
  resolvePlatformCollisions(s1, platforms);
  
  for(Sprite s: platforms)
    s.display();
    
ArrayList<Sprite> collision_list = checkCollisionList(s1, coins);  
  if(collision_list.size() > 0){    
    for(Sprite c: collision_list) {
      coins.remove(c);
      score++;
    }  
 textSize(32);
  fill(255, 0, 0);
  text("Coins:" + score, 50, 50); 
  }
}   
// returns whether the two Sprites s1 and s2 collide.
public boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  // fill in code here
  // see: https://youtu.be/RMmo3SktDJo
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s,p))
      collision_list.add(p);
  }
  return collision_list;
}

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  // add gravity to change_y of sprite
  s.change_y += GRAVITY;
  s.center_y += s.change_y;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  if(col_list.size() >0) {
  Sprite collided = col_list.get(0);
  if(s.change_y > 0){
    s.setBottom(collided.getTop());
  }
  else if(s.change_y < 0) {
    s.setTop(collided.getBottom());
  }
  s.change_y = 0;
  }
  s.center_x += s.change_x;
  col_list = checkCollisionList(s, walls);
  if(col_list.size() >0) {
  Sprite collided = col_list.get(0);
  if(s.change_x > 0){
    s.setRight(collided.getLeft());
  }
  else if(s.change_x < 0) {
    s.setLeft(collided.getRight());
  }
  }
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls) {
 s.center_y += 5; 
 ArrayList<Sprite> col_list = checkCollisionList(s, walls);
 s.center_y -= 5;
 if(col_list.size() > 0) {
  return true; 
 }
 else 
   return false;
}

void scroll() {
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if(s1.getRight() > right_boundary) {
    view_x += s1.getRight() - right_boundary;
}
  float left_boundary = view_x + LEFT_MARGIN;
  if(s1.getLeft() < left_boundary) {
    view_x -= left_boundary - s1.getLeft();
}
  float top_boundary = view_y + VERTICAL_MARGIN;
  if(s1.getTop() < top_boundary) {
    view_y -= top_boundary - s1.getTop();
}
  translate(-view_x, -view_y);
}


 
void keyPressed(){
// move character using 'a', 's', 'd', 'w'. Also use MOVE_SPEED above.
  if(key == 'a'){
    s1.change_x = -MOVE_SPEED; 
  }
  else if(key == 'd') {
    s1.change_x = MOVE_SPEED;
  }
  else if(key == 'w'&& isOnPlatforms(s1, platforms)) {
    s1.change_y = -JUMP_SPEED;
  }
  else if(key == 's') {
    s1.change_y = MOVE_SPEED;
  }
}
void keyReleased(){
// if key is released, set change_x, change_y back to 0
  if(key == 'a'){
    s1.change_x = 0; 
  }
  else if(key == 'd') {
    s1.change_x = 0;
  }
  else if(key == 'w') {
    s1.change_y = 0;
  }
  else if(key == 's') {
    s1.change_y = 0;
  }
  }
  
void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++) {
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++) {
      if(values[col].equals("1")) {
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("2")){
        Sprite s = new Sprite(coin, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
    }
    else if(values[col].equals("3")){
        Sprite s = new Sprite(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("4")){
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("5")){
        Sprite s = new Sprite(tile, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("6")){
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
    }
  }
}

 
  
}
