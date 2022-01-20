using System
using System.Collections.Generic
using System.Drawing
using System.Text
using System.Linq
using System.Windows

class Day09Solver inherit SolverBase

   private property Data as List<List<int>> auto
   private property Neighbours as List<Point> auto := List<Point>{4}{Point{-1,0},Point{0,1},Point{0,-1},Point{1,0}}

   private method GetLowPoints() as List<Point>
      var lowPoints := List<Point>{}
      for var y := 0 upto self.Data.Count-1
         for var x := 0 upto self.Data[y].Count-1
            var adjacents := self.Neighbours.Select({i => Point{i.X+x,i.Y+y}}).Where({q => self.CheckIsPointValid(q)}).ToList()
            if adjacents.All({q => self.Data[q.Y][q.X] > self.Data[y][x] })
               lowPoints.Add(Point{x, y})
            endif
         next
      next
      return lowPoints

   private method GetBasinSize(lp as Point) as int
      var q := Queue<Point>{}
      q.Enqueue(lp)
      var basin := List<Point>{}
      do while q.Count > 0
         var p := q.Dequeue()
         basin.Add(p)
         var adjacents := self.Neighbours.Select({i => Point{i.X+p.X,i.Y+p.Y}}).Where({x => self.CheckIsPointValid(x) .and. self.Data[x.Y][x.X] != 9 .and. !basin.Contains(x) .and. !q.Contains(x)}).ToList()
         adjacents.ForEach({x => q.Enqueue(x)})
      enddo
      return basin.Count

   private method CheckIsPointValid(p as Point) as logic
      return p.X >= 0 .and. p.X < self.Data.First().Count .and. p.Y >= 0 .and. p.Y < self.Data.Count

   protected override method Parse(data as List<string>) as void
      self.Data := data.Select({l => l.ToCharArray().Select({i => int32.Parse(i.ToString())}).ToList()}).ToList()
      return

   protected override method Solve1() as object
      return self.GetLowPoints().Select({i => self.Data[i.Y][i.X]+1}).Sum()

   protected override method Solve2() as object
      return self.GetLowPoints().Select({i => self.GetBasinSize(i)}).OrderByDescending({i => i}).Take(3).Aggregate({x, y => x * y})

end class