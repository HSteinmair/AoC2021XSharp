using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day02Solver inherit SolverBase

   private property PosX as int auto
   private property PosY as int auto
   private property PosYWithAim as int auto

   private method Forward(val as int) as void
      self:PosX += val
      if self:PosY != 0
         self:PosYWithAim += val*self:PosY
      endif
      return

   protected override method Parse(data as List<string>) as void
      self:PosX := 0
      self:PosY := 0
      self:PosYWithAim := 0
      foreach var line in data
         var val := int32.Parse(line:Substring(line.IndexOf(" ")+1))
         if line.StartsWith("up")
            self:PosY -= val
         elseif line.StartsWith("down")
            self:PosY += val
         endif
         if line.StartsWith("forward")
            self:Forward(val)
         endif
      next
      return

   protected override method Solve1() as object
      return self:PosX*self:PosY

   protected override method Solve2() as object
      return self:PosX*self:PosYWithAim

end class
