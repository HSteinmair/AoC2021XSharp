using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day21Solver inherit SolverBase

   private property Player1 as Player auto
   private property Player2 as Player auto
   private property Wins as int64[] auto

   protected override method Parse(data as List<string>) as void
      var players := data.Select({i => int32.Parse(i.Split(': ')[1].Trim())}).ToArray()
      self.Player1 := Player{players[0]}
      self.Player2 := Player{players[1]}
      return

   protected override method Solve1() as object
      var game := DiracDiceDeterministic{self.Player1, self.Player2}
      var turnP1 := true
      do while game.GetHighScore() < 1000
         game.Turn(turnP1)
         turnP1 := !turnP1
      enddo
      return game.GetLoosingScore() * game.TotalRolls

   protected override method Solve2() as object
      self.Wins := <int64>{0L, 0L}
      var games := HashSet<DiracDiceQuantum>{}{DiracDiceQuantum{self.Player1.Clone(), self.Player2.Clone()}}
      var player := 0
      var quantumRolls := self.GetQuantumRolls()
      do while games.Count > 0
         var newGames := List<DiracDiceQuantum>{}
         foreach var game in games
            foreach var t in game.Turn(player, quantumRolls)
               self.CheckHandleWin(t, newGames)
            next
         next
         games := newGames.OrderByDescending({i => iif(player==0, i.Player2.Score, i.Player1.Score)}).ToHashSet()
         player := (player + 1) % 2
      enddo
      return wins.Max()

      private method GetQuantumRolls() as Dictionary<int,int>
         var res := Dictionary<int,int>{}
         for var t1 := 1 upto 3
            for var t2 := 1 upto 3
               for var t3 := 1 upto 3
                  var move := t1+t2+t3
                  if res.ContainsKey(move)
                     res[move]++
                  else
                     res.Add(move,1)
                  endif
               next
            next
         next
         return res

      private method CheckHandleWin(g as DiracDiceQuantum, newGames as List<DiracDiceQuantum>) as void
         var p := g.GetWinner(21)
         if p == -1
            var t := newGames.FirstOrDefault({i => i.ToString() == g.ToString()})
            if t == null
               newGames.Add(g)
            else
               t.Count += g.Count
            endif
         else
            self.Wins[p] += g.Count
         endif
         return

end class

public class Player
   public property Position as int auto
   public property Score as int64 auto

   public constructor(pos := 0 as int, scr := 0L as int64)
      self.Position := pos
      self.Score := scr
      return

   public method Clone() as Player
      return Player{self.Position, self.Score}

   public method Move(val as int) as void
      self.Position := ((self.Position + val - 1) % 10) + 1
      self.Score += self.Position
      return

   public method QuantumMove(val as int) as Player
      var copy := self.Clone()
      copy.Move(val)
      return copy

      public method ToString() as string
         return ie"(Pos: {self.Position}; Score: {self.Score})"
end class

public class DiracDiceBase
   public property Player1 as Player auto
   public property Player2 as Player auto

   public constructor(P1 as Player, P2 as Player)
      self.Player1 := p1
      self.Player2 := p2
      return

   public method GetHighScore() as int64
      return Math.Max(self.Player1.Score, self.Player2.Score)

   public method GetLoosingScore() as int64
      return Math.Min(self.Player1.Score, self.Player2.Score)

end class

public class DiracDiceDeterministic inherit DiracDiceBase
   public property LastRoll as int auto := 0
   public property TotalRolls as int auto := 0

   public constructor(p1 as Player, p2 as Player) ; super(p1, p2)
      return

   public method Roll(times as int) as int
      var res := 0
      for var t := 1 upto times
         if self.LastRoll > 99
            self.LastRoll := 0
         endif
         self.TotalRolls++
         self.LastRoll++
         res += self.LastRoll
      next
      return res

   public method Turn(turnP1 as logic) as void
      var p := iif(turnP1, self.Player1, self.Player2)
      p.Move(self.Roll(3))
      return
end class

public class DiracDiceQuantum inherit DiracDiceBase

   public property Count as int64 auto

   public constructor(p1 as Player, p2 as Player, cnt := 1 as int64) ; super(p1, p2)
      self.Count := cnt
      return

   public method GetWinner(target as int) as int
      if self.Player1.Score >= target
         return 0
      elseif self.Player2.Score >= target
         return 1
      endif
      return -1

   public method Turn(player as int, quantumRolls as Dictionary<int,int>) as List<DiracDiceQuantum>
      var res := List<DiracDiceQuantum>{}
      foreach var qr in quantumRolls
         if player == 0
            res.Add(DiracDiceQuantum{self.Player1.QuantumMove(qr.Key), self.Player2.Clone(), self.Count*qr.Value})
         else
            res.Add(DiracDiceQuantum{self.Player1.Clone(), self.Player2.QuantumMove(qr.Key), self.Count*qr.Value})
         endif
      next
      return res

      public method ToString() as string
         return ie"(P1: {self.Player1.ToString()}; P2: {self.Player2.ToString()})"

end class