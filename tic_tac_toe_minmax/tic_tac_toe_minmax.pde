String[][] board = {
{"","","",},
{"","","",},
{"","","",}
};

String human = "X";
String ai = "O";
String currentPlayer;


void setup()
{
  size(640,640);
  frameRate(1);
  textSize(128);
  noFill();
  stroke(0);
  strokeWeight(4);
  currentPlayer = human;
}

boolean equals3(String a, String b, String c)
{
  return (a==b && b==c && a != "");
}

void clearBoard()
{
 for(Integer i = 0; i < 3; i++)
  {
    for(Integer j = 0; j < 3; j++)
    {
      board[i][j] = "";
    }
  }
}

String checkWinner()
{
  String winner = null;
  //horizontal
  for(int i = 0; i < 3; i++)
  {
    if(equals3(board[i][0],board[i][1],board[i][2]))
    {
        winner = board[i][0];
    }
  }
  //vertical
  for(int i = 0; i < 3; i++)
  {
    if(equals3(board[0][i],board[1][i],board[2][i]))
    {
        winner = board[0][i];
    }
  }
  //diagonal
  if(equals3(board[0][0],board[1][1],board[2][2]))
  {
      winner = board[0][0];
  }
  if(equals3(board[2][0],board[1][1],board[0][2]))
  {
      winner = board[2][0];
  }
      
  if(winner == null && checkFullBoard(board))
  {
    //and all available tiles are gone
    //tie
    return "tie";
  }
  else if(winner == null)
  {
    //no winner
    return winner;
  }
  else
  {
    //log winner!
    return winner;
  }
}

boolean checkFullBoard(String[][] board)
{
  //check if all tiles are full
  int a = 0;
  for(Integer i = 0; i < 3; i++)
      {
      for(Integer j = 0; j < 3; j++)
      {
        //spot available?
        if(board[i][j] == "")
        {
          a++;
        }
      }
    }
    if(a == 0)
    {
      return true;
    }
    else
    {
      return false;
    }
}

double minimax(String[][] board, int depth, boolean isMax)
{
  String result = checkWinner();
  if(result != null)
  {
    if(result == "X")
    {
      return -1;
    }
    else if(result == "O")
    {
      return 1;
    }
    else if(result == "tie")
    {
      return 0;
    }
  }
  
  
  if(isMax)
  {
    double bestScore = Double.NEGATIVE_INFINITY;
     for(Integer i = 0; i < 3; i++)
      {
      for(Integer j = 0; j < 3; j++)
      {
        //spot available?
        if(board[i][j] == "")
        {
          board[i][j] = ai;
          double score = minimax(board,depth++,false);
          board[i][j] = "";
          bestScore = Math.max(score, bestScore);
        }
      }
    }
    return bestScore;
  }
  else
  {
   double bestScore = Double.POSITIVE_INFINITY;
    for(Integer i = 0; i < 3; i++)
      {
      for(Integer j = 0; j < 3; j++)
      {
        //spot available?
        if(board[i][j] == "")
        {
          board[i][j] = human;
          double score = minimax(board,depth++,true);
          board[i][j] =  "";
          bestScore = Math.min(score, bestScore);
        }
      }
     }
   return bestScore;
    
  }
}
void bestMove()
{
  //AI turn
  double bestScore = Double.NEGATIVE_INFINITY;
  String bestMove = "";
  //check availability
   for(Integer i = 0; i < 3; i++)
  {
    for(Integer j = 0; j < 3; j++)
    {
      if(board[i][j] == "")
      {
        //if spot is available
        board[i][j] = ai;
        int depth = 0;
        //call minimax on this partiuclar board scenario
        double score = minimax(board, depth, false);
        board[i][j] = "";
        if(score > bestScore) 
        {
          bestScore = score;
          bestMove = (i.toString() + ":" + j.toString());
          System.out.println(score);
        }
      }
    }
  }
  int i = Integer.parseInt(bestMove.split(":")[0]);
  int j = Integer.parseInt(bestMove.split(":")[1]);
  board[i][j] = ai;
  currentPlayer = human;
}

void mousePressed() {
  if(currentPlayer == human)
  {
    int w =  width/3;
    int h = height/3;
    //human make turn
    int i = (int)(mouseX / w);
    int j = (int)(mouseY / h);
    //if valid turn
    if(board[i][j] == "")
    {
      board[i][j] = human;
      if(checkFullBoard(board))
      {
        clearBoard();
      }
      currentPlayer = ai;
      bestMove();
    }
  }
}

void draw()
{
  background(255);
  int w =  width/3;
  int h = height/3;
  //game board
  line(w,0,w,height);
  line(w*2,0,w*2,height);
  line(0,h,width,h);
  line(0,h*2,width,h*2);
  
  //player moves drawing
  for(int j = 0; j < 3; j++)
  {
    for(int i = 0; i < 3; i++)
    {
      int x = w*i + w/2;
      int y = h*j + h/2;
      String spot = board[i][j];
      if(spot == ai)
      {
        ellipse(x,y,w/2,w/2); //"O"
      }
      else if(spot == human)
      {
        int xr =  w/4;
        line(x-xr,y-xr,x+xr,y+xr);
        line(x+xr,y-xr,x-xr,y+xr); //"X"
      }
    }
  }
  String result = checkWinner();
  if(result != null)
  {
    clearBoard();
  }
}
