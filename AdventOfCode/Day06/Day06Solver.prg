using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day06Solver inherit SolverBase

   private property Data as List<int64> auto

   private method CountFish(daysToPass as int) as int64
      var fishCycles := self.Data// Initial situation
      var fishCyclesTemp := fishCycles.Select({i => (int64)0}).ToList()
      for var day := 0 upto daysToPass-1
         var nextGen := fishCycles[0] // the number of fishs which will produce an offspring
         for var d := 0 upto 7 // Perform the shifts
            fishCyclesTemp[d] := fishCycles[d+1]
         next
         fishCyclesTemp[6] += nextGen // the parents are put back in the cycle
         fishCyclesTemp[8] += nextGen // the new fish are added to the cycle
         fishCycles := fishCyclesTemp.ToList()
         fishCyclesTemp := fishCyclesTemp.Select({i => (int64)0}).ToList()
      next
      return fishCycles.Sum()

   protected override method Parse(data as List<string>) as void
      self.Data := List<int64>{9}{0, 0, 0, 0, 0, 0, 0, 0, 0}
      data.FirstOrDefault().Split(',').ToList().Select({i => int32.Parse(i)}).ToList().ForEach({i => self.Data[i]++})
      return

   protected override method Solve1() as object
      return self.CountFish(80)

   protected override method Solve2() as object
      return self.CountFish(256)

end class