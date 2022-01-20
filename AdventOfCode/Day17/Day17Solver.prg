using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day17Solver inherit SolverBase

   private property XMin as int auto
   private property XMax as int auto
   private property YMin as int auto
   private property YMax as int auto

   private method CheckIsPointInTargetArea(x as int, y as int) as logic
      return XMin <= x .and. x <= self.XMax .and. self.YMin <= y .and. y <= self.YMax

   private method LaunchProbes() as Tuple<int,int>
      local vel as int[]
      local pos as int[]
      var hits := 0
      var TotalMaxY := self.YMin
      for var y := self.YMin upto Math.Abs(self.YMin)
         for var x := 1 upto self.XMax
            vel := <int>{x, y}
            pos := <int>{0, 0}
            var maxY := 0
            var hit := false
            do while pos[0] <= self.XMax .and. pos[1] >= self.YMin
               pos[0] += vel[0]
               pos[1] += vel[1]
               maxY := Math.Max(maxY, pos[1])
               if vel[0] > 0
                  vel[0]--
               elseif vel[0] < 0
                  vel[0]++
               endif
               vel[1]--
               if self.CheckIsPointInTargetArea(pos[0], pos[1])
                  hit := true
               endif
            end do
            if hit
               hits++
               TotalMaxY := Math.Max(TotalMaxY, maxY)
            endif
         next
      next
      return Tuple.Create(TotalMaxY, hits)

   protected override method Parse(data as List<string>) as void
      var xy := data.First().Replace("target area: x=", "").Replace(" y=", "").Replace("..", ".").Replace(",", ".").Split('.')
      self.XMin := int32.Parse(xy[0])
      self.XMax := int32.Parse(xy[1])
      self.YMin := int32.Parse(xy[2])
      self.YMax := int32.Parse(xy[3])
      return

   protected override method Solve1() as object
      return self.LaunchProbes().Item1

   protected override method Solve2() as object
      return self.LaunchProbes().Item2

end class