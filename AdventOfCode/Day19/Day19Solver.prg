using System
using System.Collections.Generic
using System.Text
using System.Linq
using System.Numerics

class Day19Solver inherit SolverBase

   private property Data as HashSet<Scanner> auto

   private class Scanner
      public property ID as int auto
      public property Position as Vector3 auto := Vector3.Zero
      public property Rotation as int auto
      public property Beacons as List<Vector3> auto := List<Vector3>{}

      public property BeaconsWithPos as List<Vector3> get self.Beacons.Select({i => self.RotateBeacon(i)}).Select({i => Vector3{self.Position.X+i.X, self.Position.Y+i.Y, self.Position.Z+i.Z}}).ToList()

      private method RotateBeacon(b as Vector3) as Vector3
         var x := b.X
         var y := b.Y
         var z := b.Z
         switch (self.Rotation % 6)
            case 0
               // No Change
               x := b.X
               y := b.Y
               z := b.Z
            case 1
               x := -b.X
               y := b.Y
               z := -b.Z
            case 2
               x := b.Y
               y := -b.X
               z := b.Z
            case 3
               x := -b.Y
               y := b.X
               z := b.Z
            case 4
               x := b.Z
               y := b.Y
               z := -b.X
            case 5
               x := -b.Z
               y := b.Y
               z := b.X
         end switch

         switch ((self.Rotation / 6) % 4)
            case 0
               // No change
               Vector3{x, y, z}
            case 1
               return Vector3{x, -z, y}
            case 2
               return Vector3{x, -y, -z}
            case 3
               return Vector3{x, z, -y}
         end switch
         return Vector3{x, y, z}

      private method Clone() as Scanner
         var copy := Scanner{}
         copy.ID := self.ID
         copy.Position := self.Position
         copy.Rotation := self.Rotation
         copy.Beacons := self.Beacons
         return copy

      public method GetRotatedScanner(offset := 1 as int) as Scanner
         var copy := self.Clone()
         copy.Rotation += offset
         return copy

      public method GetMovedScanner(pos as Vector3) as Scanner
         var copy := self.Clone()
         copy.Position := pos
         return copy

   end class

   private method GetScanners() as HashSet<Scanner>
      var scanners := self.Data.Select({i => i}).ToHashSet()
      var located := HashSet<Scanner>{}
      var q := Queue<Scanner>{}
      var start := scanners.First()
      located.Add(start)
      q.Enqueue(start)
      scanners.Remove(start)
      do while q.Count > 0
         var s := q.Dequeue()
         foreach var toCheck in scanners.ToArray()
            var tmp := self.TryMatch(s, toCheck)
            if tmp != null
               located.Add(tmp)
               q.Enqueue(tmp)
               scanners.Remove(toCheck)
            endif
         next
      end do
      return located

   private method TryMatch(sA as Scanner, sB as Scanner) as Scanner
      var beaconsA := sA.BeaconsWithPos.ToHashSet()
      foreach var bA in beaconsA.Take(beaconsA.Count - 11)
         for var r := 0 upto 23
            var beaconsB := sB.BeaconsWithPos.ToHashSet()
            foreach var bB in beaconsB.Take(beaconsB.Count - 11)
               var center := Vector3{bA.X - bB.X, bA.Y - bB.Y, bA.Z - bB.Z}
               var newScanner := sB.GetMovedScanner(center)
               if newScanner.BeaconsWithPos.Where({i => beaconsA.Contains(i)}).Count() >= 12
                  return newScanner
               endif
            next
            sB := sB.GetRotatedScanner()
         next
      next
      return null

   private method GetManhattanDistance(sA as Scanner, sB as Scanner) as int
      return Math.Abs((int)(sA.Position.X - sB.Position.X)) + Math.Abs((int)(sA.Position.Y - sB.Position.Y)) + Math.Abs((int)(sA.Position.Z - sB.Position.Z))

   protected override method Parse(data as List<string>) as void
      self.Data := HashSet<Scanner>{}
      var coords := List<Vector3>{}
      var cnt := 0
      data.Add("---")
      foreach var line in data.Skip(1)
         if line.StartsWith("---") .and. coords.Count > 0
            self.Data.Add(Scanner{}{ID := cnt, Beacons := coords.ToList() })
            cnt++
            coords.Clear()
         elseif !string.IsNullOrEmpty(line)
            var tmp := line.Split(',')
            coords.Add(Vector3{int32.Parse(tmp[0]), int32.Parse(tmp[1]), int32.Parse(tmp[2])})
         endif
      next
      return

   protected override method Solve1() as object
      return self.GetScanners().SelectMany({i => i.BeaconsWithPos}).Distinct().Count()

   protected override method Solve2() as object
      var scanners := self.GetScanners().ToList()
      return scanners.SelectMany({i => scanners.Where({e => i.ID != e.ID}).Select({e => self.GetManhattanDistance(e, i)})}).ToList().Max()

end class