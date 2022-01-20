using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day04Solver inherit SolverBase

   private property Numbers as List<int> auto
   private property Boards as List<BingoBoard> auto

   private class BingoBoard
      public property Bingo as logic auto
      public property Board as List<List<int>> auto := List<List<int>>{5}
      public property Marker as List<List<int>> auto := List<List<int>>{5}

      private method InitMarker() as void
         for var x := 0 upto 4
            self:Marker:Add(List<int>{5})
            for var y := 0 upto 4
               self:Marker[x]:Add(0)
            next
         next
         return

      private method Mark(x as int, y as int) as logic
         self:Marker[x][y] := 1
         if self:Marker[x].Sum() == 5 ;
            .or. self:Marker:Select({i => i[y]}):ToList():Sum() == 5
            self:Bingo := true
         endif
         return self:Bingo

      public constructor(boardLS as List<string>)
         self.Board := boardLS.Select({l => l.Split(' ', StringSplitOptions.RemoveEmptyEntries).ToList().Where({q => !string.IsNullOrWhiteSpace(q)}).Select({i => int32.Parse(i)}).ToList()}).ToList()
         self.InitMarker()
         return

      public method EvalDrawnNumber(n as int) as logic
         for var x := 0 upto 4
            var y := self.Board[x].IndexOf(n)
            if y >= 0
               return self:Mark(x, y)
            endif
         next
         return false

      public method GetScore(n as int) as int
         var score := 0
         for var x := 0 upto 4
            for var y := 0 upto 4
               if self:Marker[x][y] == 0
                  score += self:Board[x][y]
               endif
            next
         next
         return score*n
   end class

   private method PlayBingo(win as logic) as int
      foreach var n in self:Numbers
         foreach var bb in self:Boards
            if bb.EvalDrawnNumber(n)
               if win .or. self.Boards.Where({q => !q.Bingo}).Count() == 0
                  return bb.GetScore(n)
               endif
            endif
         next
      next
      return -1

   protected override method Parse(lines as List<string>) as void
      self:Numbers := lines.FirstOrDefault().Split(',').Select({i => int32.Parse(i)}).ToList()
      self:Boards := List<BingoBoard>{}
      var board := List<string>{}
      lines.Add(" ") // To add last 5 lines as Board
      foreach var line in lines.Where({q, index => index>1})
         if string.IsNullOrWhiteSpace(line)
            self:Boards.Add(BingoBoard{board})
            board.Clear()
         else
            board.Add(line)
         endif
      next
      return

   protected override method Solve1() as object
      return self:PlayBingo(true)

   protected override method Solve2() as object
      return self:PlayBingo(false)

end class