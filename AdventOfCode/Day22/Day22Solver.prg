using System
using System.Collections.Generic
using System.Text
using System.Linq
using System.Numerics

class Day22Solver inherit SolverBase

   private property Data as List<Instruction> auto

   private class Instruction
      public property IsON as logic auto
      public property Min as Vector3 auto
      public property Max as Vector3 auto
      public property IsValidCuboid() as logic get self.Min.X <= self.Max.X .and. self.Min.Y <= self.Max.Y .and. self.Min.Z <= self.Max.Z

      public method GetCuboidSize() as int64
         var res := (1L + (int64)(self.Max.X - self.Min.X)) * (1L + (int64)(self.Max.Y - self.Min.Y)) * (1L + (int64)(self.Max.Z - self.Min.Z))
         if !self.IsON
            res *= -1L
         endif
         return res
   end class

   private method GetOverlap(inst1 as Instruction, inst2 as Instruction) as Instruction
      var inst := Instruction{}{IsON := !inst2.IsON}
      inst.Min := Vector3{Math.Max(inst1.Min.X, inst2.Min.X), Math.Max(inst1.Min.Y, inst2.Min.Y), Math.Max(inst1.Min.Z, inst2.Min.Z)}
      inst.Max := Vector3{Math.Min(inst1.Max.X, inst2.Max.X), Math.Min(inst1.Max.Y, inst2.Max.Y), Math.Min(inst1.Max.Z, inst2.Max.Z)}
      return inst

   private method GetCuboid(min as Vector3, max as Vector3, lowerBound as int, upperBound as int) as List<Vector3>
      var res := List<Vector3>{}
      if max.X < lowerBound .or. min.X > upperBound ;
         .or. max.Y < lowerBound .or. min.Y > upperBound ;
         .or. max.Z < lowerBound .or. min.Z > upperBound
         return res
      endif
      for var x := min.X upto max.X
         for var y := min.Y upto max.Y
            for var z := min.Z upto max.Z
               if x >= lowerBound .and. x <= upperBound ;
                  .and. y >= lowerBound .and. y <= upperBound ;
                  .and. z >= lowerBound .and. z <= upperBound
                  res.Add(Vector3{x, y, z})
               endif
            next
         next
      next
      return res

   protected override method Parse(data as List<string>) as void
      self.Data := List<Instruction>{}
      foreach var line in data
         var tmp := line.Replace("on ","").Replace("off ","").Replace("x=","").Replace("y=","").Replace("z=","").Replace("..",",").Split(',').Select({i => int32.Parse(i.ToString())}).ToArray()
         self.Data:Add(Instruction{}{IsOn := line.StartsWith("on"), Min := Vector3{tmp[0],tmp[2],tmp[4]}, Max := Vector3{tmp[1],tmp[3],tmp[5]}})
      next
      return

   protected override method Solve1() as object
      var map := Dictionary<Vector3, logic>{}
      foreach var inst in self.Data
         foreach var cube in self.GetCuboid(inst.Min, inst.Max, -50, 50)
            if map.ContainsKey(cube)
               map[cube] := inst.IsON
            else
               map.Add(cube, inst.IsON)
            endif
         next
      next
      return map.Where({i => i.Value}).Count()

   protected override method Solve2() as object
      var cuboids := List<Instruction>{}
      foreach var inst in self.Data
         cuboids.AddRange(cuboids.Select({i => self.GetOverlap(inst, i)}).Where({i => i.IsValidCuboid}).ToList())
         if inst.IsON
            cuboids.Add(inst)
         endif
      next
      return cuboids.Sum({i => i.GetCuboidSize()})

end class