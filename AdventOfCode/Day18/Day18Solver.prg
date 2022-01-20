using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day18Solver inherit SolverBase

   private property Data as List<SnailfishNumber> auto

   private class SnailfishNumber
      public property Val as int auto
      public property Lvl as int auto

      public property NextSN as SnailfishNumber auto
      public property PrevSN as SnailfishNumber auto

      public constructor(snValue := 0 as int, snLevel := 0 as int)
         self.Val := snValue
         self.Lvl := snLevel
         return

      public constructor(copy as SnailfishNumber)
         self.Val := copy.Val
         self.Lvl := copy.Lvl
         var act := self
         var cloneAct := copy.NextSN
         do while cloneAct != null
            act.NextSN := SnailfishNumber{cloneAct.val, cloneAct.Lvl}{PrevSN := act}
            cloneAct := cloneAct.NextSN
            act := act.NextSN
         enddo
         return
   end class

   private method ParseExpression(exp as string) as SnailfishNumber
      var sn := SnailfishNumber{}
      var act := sn
      var lvl := 0
      foreach var c in exp
         if c == '['
            lvl++
         elseif c == ']'
            lvl--
         endif
         if char.IsDigit(c)
            act.Val := int32.Parse(c.ToString())
            act.Lvl := lvl-1
            act.NextSN := SnailfishNumber{}{PrevSN := act}
            act := act.NextSN
         endif
      next
      act.PrevSN.NextSN := null
      return sn

   private method Add(sn1 as SnailfishNumber, sn2 as SnailfishNumber) as SnailfishNumber
      var sn := SnailfishNumber{sn1}
      var snToAdd := SnailfishNumber{sn2}
      var act := sn
      var tail := sn
      do while act != null
         act.Lvl++
         tail := act
         act := act.NextSN
      enddo
      act := snToAdd
      do while act != null
         act.Lvl++
         act := act.NextSN
      enddo
      tail.NextSN := snToAdd
      snToAdd.PrevSN := tail
      return sn

   private method AddAndReduce(sn1 as SnailfishNumber, sn2 as SnailfishNumber) as SnailfishNumber
      var reduced := self.Add(sn1, sn2)
      var continue := true
      do while continue
         continue := false
         #Region Explode
         var act := reduced
         do while act != null
            if act.Lvl >= 4
               var left := act
               var right := act.NextSN
               var sn := SnailfishNumber{0, act.Lvl-1}
               if left.PrevSN != null
                  left.PrevSN.Val += left.Val
                  sn.PrevSN := left.PrevSN
                  sn.PrevSN.NextSN := sn
               else
                  reduced := sn
               endif
               if right.NextSN != null
                  right.NextSN.Val += right.Val
                  sn.NextSN := right.NextSN
                  sn.NextSN.PrevSN := sn
               endif
               continue := true
         exit
            endif
            act := act.NextSN
         enddo
         #EndRegion Explode
         #Region Split
         if !continue
            act := reduced
            do while act != null
               if act.Val > 9
                  var left := SnailfishNumber{0, act.Lvl+1}{PrevSN := act.PrevSN}
                  var right := SnailfishNumber{0, act.Lvl+1}{NextSN := act.NextSN}
                  left.NextSN := right
                  right.PrevSN := left
                  if left.PrevSN == null
                     reduced := left
                  else
                     left.PrevSN.NextSN := left
                  endif
                  if right.NextSN != null
                     right.NextSN.PrevSN := right
                  endif
                  left.Val := act.Val/2
                  right.Val := iif((act.Val % 2 == 0), left.Val, left.Val+1)
                  continue := true
            exit
               endif
               act := act.NextSN
            enddo
         endif
         #EndRegion Split
      enddo
      return reduced

   private method Magnitude(sn as SnailfishNumber) as int
      var start := SnailfishNumber{sn}
      var defLvl := 4
      do while start.NextSN != null
         defLvl--
         var act := start
         do while act != null .and. act.NextSN != null
            if act.Lvl == act.NextSN.Lvl .and. act.Lvl == defLvl
               act.Lvl--
               act.Val *= 3
               act.Val += act.NextSN.Val * 2
               act.NextSN := act.NextSN.NextSN
               if act.NextSN != null
                  act.NextSN.PrevSN := act
               endif
            endif
            act := act.NextSN
         enddo
      enddo
      return start.Val

   protected override method Parse(data as List<string>) as void
      self.Data := data.Select({i => self.ParseExpression(i)}).ToList()
      return

   protected override method Solve1() as object
      var sn := self.Data.Aggregate({x, y => self.AddAndReduce(x, y)})
      return self.Magnitude(sn)

   protected override method Solve2() as object
      var res := 0
      for var n := 0 upto self.Data.Count-1
         var sn1 := self.Data[n]
         foreach var sn2 in self.Data.Skip(n+1)
            res := Math.Max(res, self.Magnitude(self.AddAndReduce(sn1, sn2)))
            res := Math.Max(res, self.Magnitude(self.AddAndReduce(sn2, sn1)))
         next
      next
      return res

end class