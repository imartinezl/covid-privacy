class kdtree
{
  vec2 location;
  kdtree leftChild, rightChild;

  kdtree(ArrayList<vec2> pointList, int depth)
  {
    if (pointList.size() > 1)
    {
      sortNodes(pointList, depth%2);
      location = pointList.get(floor(pointList.size()/2));
      //String printString = (str(depth) + ": " +str(new ArrayList<vec2>(pointList.subList(0,floor(pointList.size()/2))).size()) + ' ');
      if (new ArrayList<vec2>(pointList.subList(0, floor(pointList.size()/2))).size() > 0)
        leftChild  = new kdtree(new ArrayList<vec2>(pointList.subList(0, floor(pointList.size()/2))), depth+1);
      //println(printString + new ArrayList<vec2>(pointList.subList(floor(pointList.size()/2)+1,pointList.size())).size());
      if (new ArrayList<vec2>(pointList.subList(floor(pointList.size()/2)+1, pointList.size())).size() > 0)
        rightChild = new kdtree(new ArrayList<vec2>(pointList.subList(floor(pointList.size()/2)+1, pointList.size())), depth+1);
      //point(location.x,location.y);
    } else if (pointList.size() == 1);
    {
      location = pointList.get(0);
      //strokeWeight(5);
      //stroke(0);
      //point(location.x,location.y);
    }
  }

  void sortNodes(ArrayList<vec2> input, int axis)
  {
    Comparator<vec2> XCompare = new XComparator();
    Comparator<vec2> YCompare = new YComparator(); 
    if (axis == 1) Collections.sort(input, XCompare);
    else           Collections.sort(input, YCompare);
  }
}

ArrayList<vec2> listofPoints = new ArrayList<vec2>();
IntList nb = new IntList();
int cont = 0;

void move() {
  for (vec2 v : listofPoints) {
    v.x += random(-1, 1);
    v.y += random(-1, 1);
  }
}

void display() {
  int cont_display = 0;
  nb.shuffle();
  for (int i : nb) {
    vec2 v = listofPoints.get(i);
    fill(0);
    circle(v.x, v.y, 4);
    cont_display++;
    if (cont_display > 2000) break;
  }
}

void setup()
{
  size(800, 800);
  for (int i = 0; i < 0; i++)
  {
    listofPoints.add(new vec2(random(20, width-20), random(20, height-20)));
    nb.append(cont);
    cont++;
  }
  //noLoop();
}

kdtree testBed;
void draw()
{
  background(255);
  if (mousePressed) {
    for (int i=0; i < 10; i++) {
      listofPoints.add(new vec2(mouseX + random(-20, 20), mouseY + random(-20, 20)));
      nb.append(cont);
      cont++;
    }
  }
  move();
  //testBed = new kdtree(listofPoints,0);

  display();
  fill(0);
  text(frameRate, 10, 10);
  text(listofPoints.size(), 10, 20);
}
