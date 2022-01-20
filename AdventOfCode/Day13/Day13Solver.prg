using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day13Solver inherit SolverBase

   private property Data as List<List<int>> auto
   private property Instr as List<string> auto

   private method getEmptyMap(dimensionX as int, dimensionY as int) as List<List<int>>
      return self.getMap<int>(dimensionX, dimensionY, 0)

   private method GetMapForFolding(axis as string, val as int) as List<List<int>>
      if axis == "y"
         return self.Data.Where({i,index => index < val}).Select({i => i}).ToList()
      endif
      return self.getEmptyMap(val-1, self.Data.Count-1)

   private method Fold(axis as string, val as int) as void
      var newMap := self.GetMapForFolding(axis, val)
      var startY := 0
      if axis == "y"
         startY := val+1
      endif
      for var y := startY upto self.Data.count-1
         for var x := 0 upto self.Data[y].Count-1
            if self.Data[y][x] == 1
               var newY := y
               var newX := x
               if axis == "y"
                  newY := val-(y-val)
               elseif axis == "x" .and. x > val
                  newX := val-(x-val)
               endif
               newMap[newY][newX] := 1
            endif
         next
      next
      self.Data := newMap
      return

   private method GetMapString() as string
      var sB := StringBuilder{}
      self.Data.ForEach({e => sB.AppendLine(string.Join("", e.Select({i => iif(i==0, ".", "#")}).ToList()))})
      return sB.ToString()

   protected override method Parse(data as List<string>) as void
      self.Instr := data.Where({i => !string.IsNullOrWhiteSpace(i) .and. i.StartsWith("fold")}).Select({i => i.Replace("fold along ","")}).ToList()
      var coords := data.Where({i => !string.IsNullOrWhiteSpace(i) .and. !i.StartsWith("fold")}).Select({l => l.Split(',').Select({i => int32.Parse(i.ToString())}).ToList()}).ToList()
      self.Data := self.getEmptyMap(coords.Select({i => i[0]}).Max(), coords.Select({i => i[1]}).Max())
      foreach var c in coords.OrderBy({i => i[1]})
         self.Data[c[1]][c[0]] := 1
      next
      return

   protected override method Solve1() as object
      var i :=  (string)self.Instr.First()
      self.Fold(i[0].ToString(), int32.Parse(i.Split('=')[1]))
      return self.Data.Select({i => i.Sum()}).Sum()

   protected override method Solve2() as object
      foreach var i in self.Instr
         self.Fold(i[0].ToString(), int32.Parse(i.Split('=')[1]))
      next
      return ie"Map: \r\n{self.GetMapString()}"

end class