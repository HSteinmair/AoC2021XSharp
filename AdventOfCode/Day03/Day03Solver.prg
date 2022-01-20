using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day03Solver inherit SolverBase

   private property Data as List<int[]> auto

   protected override method Parse(lines as List<string>) as void
      self:Data := lines.Select({l => l.ToCharArray().Select({i => (int)i-48}).ToArray()}).ToList()
      return

   protected override method Solve1() as object
      var lineLength := self:Data:FirstOrDefault():Length
      var gammaDigit := List<char>{lineLength}
      var epsilonDigit := List<char>{lineLength}
      for var digit := 0 upto lineLength-1
         var s := self:Data:Select({i => i[digit]}):ToList():Sum()
         gammaDigit:Add(iif(s > (self:Data:Count/2),'1','0'))
         epsilonDigit:Add(iif(s > (self:Data:Count/2),'0','1'))
      next
      var gamma := Convert.ToUInt32(string.Join("",gammaDigit), 2)
      var epsilon := Convert.ToUInt32(string.Join("",epsilonDigit), 2)
      return gamma*epsilon

   protected override method Solve2() as object
      var o2 := self:GetRating(self:Data, true)
      var co2 := self:GetRating(self:Data, false)
      return o2*co2

   private method GetRating(data as List<int[]>, searchOnes as logic) as int
      var currentPos := 0
      var copy := data:Select({q => q}):ToList()
      do while copy:Count > 1
         var countOne := copy:Sum({i => i[currentPos]})
         var zeroOrOne := 0
         if (countOne > copy:Count / 2) ; // More 1's than 0's -> Take 1
            .or. (copy:Count % 2 == 0 .and. countOne == (copy:Count/2)) // Exactly 50:50 -> Take 1
            zeroOrOne := iif(searchOnes,1,0)
         else
            zeroOrOne := iif(searchOnes,0,1)
         endif
         copy := copy:Where({q => q[currentPos] == zeroOrOne}):ToList()
         currentPos++
      end do
      return Convert.ToInt32(string.Join("", copy:FirstOrDefault():Select({i => (char)(i + 48)}):ToArray()), 2)

end class