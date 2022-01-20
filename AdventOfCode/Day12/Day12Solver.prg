using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day12Solver inherit SolverBase

   private property Data as Dictionary<string,Cave> auto

   private class Cave
      public property Name as string auto
      public property BigCave as logic auto
      public property ConnectedCaves as List<Cave> auto := List<Cave>{}

      public constructor(caveName as string)
         self.Name := caveName
         self.BigCave := caveName.Any(Char.IsUpper)
         return
   end class

   private method AddCaveOrConnection(caveName1 as string, caveName2 as string) as void
      var cave1 := self.GetCave(caveName1)
      var cave2 := self.GetCave(caveName2)
      cave1.ConnectedCaves.Add(cave2)
      cave2.ConnectedCaves.Add(cave1)
      return

   private method GetCave(caveName as string) as Cave
      if !self.Data:TryGetValue(caveName, out var cave) .or. cave == null
         cave := Cave{caveName}
         self.Data.Add(caveName, cave)
      endif
      return cave

   private method SearchPaths(act as Cave, visited as List<string>, visitedSmallTwice as int) as int
      if act.Name == "end"
         return 1
      endif
      var cnt := 0
      foreach var nextCave in act.ConnectedCaves.Where({i => i.Name != "start"})
         if nextCave.BigCave .or. nextCave.Name == "end"
            cnt += self.SearchPaths(nextCave, visited, visitedSmallTwice)
         else
            if visited.Contains(nextCave.Name) .and. visitedSmallTwice == 0
               cnt += self:SearchPaths(nextCave, visited, 1)
            elseif !visited.Contains(nextCave.Name)
               var newVisited := visited.Select({i => i}).ToList()
               newVisited.Add(nextCave.Name)
               cnt += self:SearchPaths(nextCave, newVisited, visitedSmallTwice)
            endif
         endif
      next
      return cnt

   protected override method Parse(data as List<string>) as void
      self.Data := Dictionary<string,Cave>{}
      foreach var line in data
         var caves := line.Split('-')
         self.AddCaveOrConnection(caves[0], caves[1])
      next
      return

   protected override method Solve1() as object
      return self.SearchPaths(self.Data["start"], List<string>{}, -1)

   protected override method Solve2() as object
      return self.SearchPaths(self.Data["start"], List<string>{}, 0)

end class