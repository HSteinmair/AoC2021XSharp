using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day08Solver inherit SolverBase

   private property Data as List<SignalEntry> auto

   private class SignalEntry
      public property SignalPatterns as List<string> auto
      public property DigitOutput as List<string> auto

      public constructor(line as string)
         var splitRes := line.Split('|')
         self.SignalPatterns := splitRes[0].Trim().Split(' ').ToList()
         self.DigitOutput := splitRes[1].Trim().Split(' ').ToList()
         return
      end class

   private class SignalPatternAnalyzer
      private property Segments as List<string> auto

      private method ParsePatterns(patterns as List<string>) as void
         self.Segments := List<string>{10}{"","","","","","","","","",""}
         self.Segments[1] := patterns.Single({i => i.Length == 2})
         self.Segments[4] := patterns.Single({i => i.Length == 4})
         self.Segments[7] := patterns.Single({i => i.Length == 3})
         self.Segments[8] := patterns.Single({i => i.Length == 7})
         self.Segments[6] := patterns.Where({q => q.Length == 6}).Single({i => i.Intersect(self.Segments[1]).Count() == 1})

         var fSeg := self.Segments[1].Intersect(self.Segments[6]).Single() // Segment f = Bottom right
         var cSeg := self.Segments[1].Single({i => i != fSeg}) // Segment c = Top right

         self.Segments[2] :=  patterns.Where({q => q.Length == 5}).Single({i => i.Contains(cSeg) .and. !i.Contains(fSeg)})
         self.Segments[5] :=  patterns.Where({q => q.Length == 5}).Single({i => !i.Contains(cSeg) .and. i.Contains(fSeg)})
         self.Segments[3] :=  patterns.Where({q => q.Length == 5}).Single({i => i.Contains(cSeg) .and. i.Contains(fSeg)})

         var eSeg := self.Segments[2].Except(self.Segments[5]).Single({i => i != cSeg }) // Segment e = Bottom left

         self.Segments[0] := patterns.Where({q => q.Length == 6 .and. q != self.Segments[6]}).Single({i => i.Contains(eSeg)})
         self.Segments[9] := patterns.Single({i => i.Length == 6 .and. i != self.Segments[6] .and. i != self.Segments[0]})
         return

      private method GetOutPut(output as List<string>) as int
         var res := ""
         foreach var c in output
            for var n := 0 upto 9
               if self.Segments[n].Length == c.Length .and. self.Segments[n].Intersect(c).Count() == c.Length
                  res += n.ToString()
            exit
               endif
            next
         next
         return int32.Parse(res)

      public method ParseAndGetOutPut(se as SignalEntry) as int
         self.ParsePatterns(se.SignalPatterns)
         return self.GetOutPut(se.DigitOutput)
   end class

   protected override method Parse(data as List<string>) as void
      self.Data := data.Select({i => SignalEntry{i}}).ToList()
      return

   protected override method Solve1() as object
      var sum := 0
      var DigitsToSearchFor := List<int>{}{2,3,4,7}
      self.Data.ForEach({se => sum += se.DigitOutput.Where({i => DigitsToSearchFor.Exists({e => e == i.Length})}).Count()})
      return sum

   protected override method Solve2() as object
      var sum := 0
      var spa := SignalPatternAnalyzer{}
      self.Data.ForEach({se => sum += spa.ParseAndGetOutPut(se)})
      return sum


end class
