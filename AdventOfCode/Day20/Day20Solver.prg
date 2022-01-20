using System
using System.Collections.Generic
using System.Drawing
using System.Text
using System.Linq

class Day20Solver inherit SolverBase

   private property Algorithm as List<int> auto
   private property Data as List<List<int>> auto

   private method GetLitPoints() as HashSet<Point>
      var points := HashSet<Point>{}
      for var y := 0 upto self.Data.Count-1
         for var x := 0 upto self.Data[0].Count-1
            if self.Data[y][x] > 0
               points.Add(Point{x, y})
            endif
         next
      next
      return points

   private method Enhance(steps as int, points as HashSet<Point>) as HashSet<Point>
      for var s := 0 upto steps-1
         var min := Point{int32.MaxValue, int32.MaxValue}
         var max := Point{int32.MinValue, int32.MinValue}
         foreach var p in points
            min.Y := Math.Min(min.Y, p.Y)
            min.X := Math.Min(min.X, p.X)
            max.Y := Math.Max(max.Y, p.Y)
            max.X := Math.Max(max.X, p.X)
         next
         var enhanced := HashSet<Point>{}
         for var y := min.Y-1 upto max.Y+1
            for var x := min.X-1 upto max.X+1
               var idx := self.GetIndexFromPixel(Point{x, y}, (s%2 == 0), points, min, max)
               if self.Algorithm[idx] ==1
                  enhanced.Add(Point{x, y})
               endif
            next
         next
         points := enhanced.ToHashSet()
      next
      return points

   private method GetIndexFromPixel(p as Point, evenStep as logic, points as HashSet<Point>, min as Point, max as Point ) as int
      var numStr := ""
      for var dy := -1 upto 1
         for var dx := -1 upto 1
            var y := p.Y + dy
            var x := p.X + dx
            if evenStep
               numStr += iif(points.Contains(Point{x, y}), "1", "0")
            else
               if (y >= min.Y .and. y <= max.Y .and. x >= min.X .and. x <= max.X) .or. self.Algorithm[0] == 0
                  numStr += iif(points.Contains(Point{x, y}), "1", "0")
               else
                  numStr += "1"
               endif
            endif
         next
      next
      return Convert.ToInt32(numStr, 2)

   protected override method Parse(data as List<string>) as void
      self.Algorithm := data.First().ToCharArray().Select({i => (int32)iif(i=='#', 1, 0)}).ToList()
      self.Data := data.Skip(2).Select({i => i.ToCharArray().Select({i => (int32)iif(i=='#', 1, 0)}).ToList()}).ToList()
      return

   protected override method Solve1() as object
      return self.Enhance(2, self.GetLitPoints()).Count

   protected override method Solve2() as object
      return self.Enhance(50, self.GetLitPoints()).Count

end class