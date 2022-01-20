using System
using System.Collections.Generic
using System.Drawing
using System.Text
using System.Linq

class Day11Solver inherit SolverBase

   private property Data as Dictionary<Point,int> auto
   private property Neighbours as List<Point> auto := List<Point>{8}{Point{-1,0},Point{-1,-1},Point{0,-1},Point{1,-1},Point{1,0},Point{1,1},Point{0,1},Point{-1,1}}
   private property Flashes as int auto

   private method Flash(lp as Point) as void
      var q := Queue<Point>{}
      q.Enqueue(lp)
      var flashed := List<Point>{}
      do while q.Count > 0
         var p := q.Dequeue()
         flashed.Add(p)
         var adjacents := self.Neighbours.Select({i => Point{i.X+p.X,i.Y+p.Y}}).Where({x => self.Data.ContainsKey(x) .and. self.Data[x] <= 9 .and. !flashed.Contains(x) .and. !q.Contains(x)}).ToList()
         adjacents.ForEach({x => self.Data[x]++})
         adjacents.Where({x => self.Data[x] > 9}).ToList().ForEach({x => q.Enqueue(x)})
      enddo
      return

   private method GetMap(data as List<List<int>>) as Dictionary<Point,int>
      var map := Dictionary<Point, int>{}
      for var y := 0 upto data.Count-1
         for var x := 0 upto data[y].Count-1
            map.Add(Point{x, y},data[y][x])
         next
      next
      return map

   private method PostFlash() as void
      self.Flashes += self.Data.Where({i => i.Value > 9}).Count()
      self.Data.Where({i => i.Value > 9}).Select({i => i.Key}).ToList().ForEach({i => self.Data[i] := 0})
      return

   protected override method Parse(data as List<string>) as void
      self.Data := self.GetMap(data.Select({l => l.ToCharArray().Select({i => int32.Parse(i.ToString())}).ToList()}).ToList())
      return

   protected override method Solve1() as object
      for var step := 1 upto 100
         self.Data.Select({i => i.Key}).ToList().ForEach({i => self.Data[i]++})
         self.Data.Where({i => i.Value > 9}).Select({i => i.Key}).ToList().ForEach({i => self.Flash(i)})
         self.PostFlash()
      next
      return self.Flashes

   protected override method Solve2() as object
      var steps := 0
      do while self.Data.Where({i => i.Value > 9}).Count() < self.Data.Count
         steps++
         self.Data.Select({i => i.Key}).ToList().ForEach({i => self.Data[i]++})
         self.Data.Where({i => i.Value > 9}).Select({i => i.Key}).ToList().ForEach({i => self.Flash(i)})
         if self.Data.Where({i => i.Value > 9}).Count() == self.Data.Count
            return steps
         endif
         self.PostFlash()
      enddo
      return 0

end class