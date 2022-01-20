using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day01Solver inherit SolverBase

   private property Data as List<int> auto
   private property GroupedSums as List<Grp> auto

   private class Grp
      public property Count as int auto
      public property Sum as int auto

      public constructor(cnt := 0 as int)
         self:Reset(cnt)
         return

      private method Reset(cnt := 0 as int) as void
         self:Count := cnt
         self:Sum := 0
         return

      public method CheckAction(val as int, data as List<int>) as void
         if self:Count >= 3
            data:Add(self:Sum)
            self:Reset()
         else
            if self:Count >= 0
               self:Sum += val
            endif
            self:Count++
         endif
         return
   end class

   private method GetResult(data as List<int>) as int
      return data.Where({i, index => index > 0 .and. i > data[index-1]}).Count()

   protected override method Parse(lines as List<string>) as void
      self:Data := lines:Select({q => int32.Parse(q)}):ToList()
      return

   protected override method Solve1() as object
      return self:Data.Where({i, index => index > 0 .and. i > data[index-1]}).Count()

   protected override method Solve2() as object
      var data := List<int>{}
      self:GroupedSums := List<Grp>{4}{Grp{0},Grp{-1},Grp{-2},Grp{-3}}
      var val := 0
      for var pos := 0 upto self:Data:Count
         if pos < self:Data:Count
            val := self:Data[pos]
         endif
         self:GroupedSums:foreach({i => i:CheckAction(val, data)})
      next
      return self:GetResult(data)

end class
