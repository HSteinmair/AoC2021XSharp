using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day05Solver inherit SolverBase

   private property Data as List<Line> auto

   private class Line
      public property StartPosX as int auto
      public property StartPosY as int auto
      public property EndPosX as int auto
      public property EndPosY as int auto
      public property MinX as int get Math.Min(self.StartPosX, self.EndPosX)
      public property MinY as int get Math.Min(self.StartPosY, self.EndPosY)
      public property MaxX as int get Math.Max(self.StartPosX, self.EndPosX)
      public property MaxY as int get Math.Max(self.StartPosY, self.EndPosY)

      public constructor(s as string)
         var coords := s.Split('-', '>')
         self:StartPosX := int32.Parse(coords[0].Trim().Split(',')[0])
         self:StartPosY := int32.Parse(coords[0].Trim().Split(',')[1])
         self:EndPosX := int32.Parse(coords[2].Trim().Split(',')[0])
         self:EndPosY := int32.Parse(coords[2].Trim().Split(',')[1])
         return

   end class

   private method InitMap() as List<List<int>>
      var maxXPos := self.Data.Max({q => Math.Max(q.StartPosX, q.EndPosX)})
      var maxYPos := self.Data.Max({q => Math.Max(q.StartPosY, q.EndPosY)})
      var map := List<List<int>>{maxYPos+1}
      for var y := 0 upto maxYPos
         map.Add(List<int>{maxXPos+1})
         for var x := 0 upto maxXPos
            map[y].Add(0)
         next
      next
      return map

   private method AddLineToMap(l as Line, m as List<List<int>>, addDiagonalLines as logic) as void
      if l.StartPosY == l.EndPosY .or. l.StartPosX == l.EndPosX
         for var y := l.MinY upto l.MaxY
            for var x := l.MinX upto l.MaxX
               m[y][x] += 1
            next
         next
      elseif addDiagonalLines .and. ((l.MaxY-l.MinY) == (l.MaxX-l.MinX))
         var startY := l.StartPosY
         var endY := l.EndPosY
         var startX := l.StartPosX
         var endX := l.EndPosX
         if l.StartPosY > l.EndPosY
            startY := l.EndPosY
            endY := l.StartPosY
            startX := l.EndPosX
            endX := l.StartPosX
         endif
         var incX := startX < endX
         var xChange := 0
         for var y := startY upto endY
            var x := iif(incX, startX+xChange, startX-xChange)
            m[y][x] += 1
            xChange++
         next
      endif
      return

   private method CountOverlappingPoints(m as List<List<int>>) as int
      var cnt := 0
      foreach var l in m
         cnt += l.Count({i => i > 1})
      next
      return cnt

   protected override method Parse(data as List<string>) as void
      self:Data := List<Line>{}
      foreach var l in data
         self:Data:Add(Line{l})
      next
      return

   protected override method Solve1() as object
      var map := self.InitMap()
      self.Data.Foreach({l => self.AddLineToMap(l, map, false)})
      return self.CountOverlappingPoints(map)

   protected override method Solve2() as object
      var map := self.InitMap()
      self.Data.Foreach({l => self.AddLineToMap(l, map, true)})
      return self.CountOverlappingPoints(map)

end class