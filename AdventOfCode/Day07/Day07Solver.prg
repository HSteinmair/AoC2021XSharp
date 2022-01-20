using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day07Solver inherit SolverBase

   private property Data as List<int> auto

   private method GetFuel(pos as int, simple as logic) as int
      if simple
         return self.Data.Select({i => Math.Abs(i-pos)}).Sum()
      endif
      return self.Data.Select({i => Enumerable.Range(1, Math.Abs(i-pos)).Sum()}).Sum()

   private method GetLeastFuelConsumtion(simple as logic) as int
      var sum := self.GetFuel(self.Data.Min(), simple)
      for var pos := self.Data.Min()+1 upto self.Data.Max()
         var temp := self.GetFuel(pos, simple)
         sum := iif(temp < sum, temp, sum)
      next
      return sum

   protected override method Parse(data as List<string>) as void
      self.Data := data.FirstOrDefault().Split(',').ToList().Select({i => int32.Parse(i)}).ToList()
      return

   protected override method Solve1() as object
      return self.GetLeastFuelConsumtion(true)

   protected override method Solve2() as object
      return self.GetLeastFuelConsumtion(false)

end class