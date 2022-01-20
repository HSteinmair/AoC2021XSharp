using System
using System.Collections.Generic
using System.Drawing
using System.Text
using System.Linq

class Day15Solver inherit SolverBase

   private property Data as List<List<int>> auto
   private property TotalRiskMap as Dictionary<Point,int> auto
   private property Neighbours as List<Point> auto := List<Point>{4}{Point{0,1},Point{1,0},Point{-1,0},Point{0,-1}}

   public method SearchPath(map as Dictionary<Point,int>) as void
      var src := map.First().Key
      var trgt := map.Last().Key
      self.TotalRiskMap := map.ToDictionary({i => i.Key}, {i => int32.MaxValue})
      self.TotalRiskMap[src] := 0
      var visited := List<Point>{}
      var q := Queue<Point>{} // Sadly no priority queue
      q.Enqueue(src)
      do while q.Count > 0
         var p := q.Dequeue()
         if !visited.Contains(p)
            visited.Add(p)
         endif
         foreach var n in self.GetNeighbours(p, map, visited).OrderBy({i => map[i]}).ToList()
            var totRisk := self.TotalRiskMap[p] + map[n]
            self.TotalRiskMap[n] := Math.Min(totRisk,self.TotalRiskMap[n])
            if n == trgt
               return
            endif
            if !q.Contains(n)
               q.Enqueue(n)
            endif
         next
         // Workaround for using queue instead of priority queue
         var tmp := q.ToList().OrderBy({i => self.TotalRiskMap[i]}).ToList()
         q.Clear()
         tmp.ForEach({i => q.Enqueue(i)})
      enddo
      return

   private method GetNeighbours(p as Point, map as Dictionary<Point, int>, visited as List<Point>) as List<Point>
      return self.Neighbours.Select({i => Point{i.X+p.X,i.Y+p.Y}}).Where({i => map.ContainsKey(i) .and. !visited.Contains(i)}).ToList()

   private method GetMap(data as List<List<int>>) as Dictionary<Point,int>
      var map := Dictionary<Point, int>{}
      for var y := 0 upto data.Count-1
         for var x := 0 upto data[y].Count-1
            map.Add(Point{x, y},data[y][x])
         next
      next
      return map

   private method GetExpandedMap(data as List<List<int>>) as Dictionary<Point,int>
      var map := Dictionary<Point, int>{}
      var rows := data.Count
      var cols := data[0].Count
      for var y := 0 upto (rows*5)-1
         for var x := 0 upto (cols*5)-1
            if y < rows .and. x < cols
               map.Add(Point{x, y},data[y][x])
            else
               Math.DivRem(y, rows, out var oldY)
               Math.DivRem(x, cols, out var oldX)
               var dist :=  (y / rows) + (x / cols)
               var newRisk := data[oldY][oldX] + dist - 1
               newRisk := newRisk % 9 + 1
               map.Add(Point{x, y}, newRisk)
            endif
         next
      next
      return map

   protected override method Parse(data as List<string>) as void
      self.Data := data.Select({l => l.ToCharArray().Select({i => int32.Parse(i.ToString())}).ToList()}).ToList()
      return

   protected override method Solve1() as object
      self.SearchPath(self.GetMap(self.Data))
      return self.TotalRiskMap[self.TotalRiskMap.Last().Key]

   protected override method Solve2() as object
      self.SearchPath(self.GetExpandedMap(self.Data))
      return self.TotalRiskMap[self.TotalRiskMap.Last().Key]

end class