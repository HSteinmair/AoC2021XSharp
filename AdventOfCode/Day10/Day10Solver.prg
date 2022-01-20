using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day10Solver inherit SolverBase

   private property Data as List<List<string>> auto
   private property TokensOpen as string[] auto := <string>{"(","[","{","<"}
   private property TokensClose as string[] auto := <string>{")","]","}",">"}
   private property ScoreSyntax as int[] auto := <int>{3,57,1197,25137}

   private method GetSyntaxScore(chunks as List<string>) as int
      var s := Stack<string>{}
      foreach var c in chunks
         if self.TokensOpen.Contains(c)
            s.Push(c)
         elseif self.TokensClose.Contains(c)
            if !self.CheckMatching(s.Pop(),c)
               return self.ScoreSyntax[Array.IndexOf(self.TokensClose, c)]
            endif
         endif
      next
      return 0

   private method GetMissingClosingTokens(chunks as List<string>) as List<string>
      var s := Stack<string>{}
      foreach var c in chunks
         if self.TokensOpen.Contains(c)
            s.Push(c)
         elseif self.TokensClose.Contains(c) .and. self.CheckMatching((string)s.Peek(),c)
            s.Pop()
         endif
      next
      return s.ToList().Select({i => self.TokensClose[Array.IndexOf(self.TokensOpen, i)]}).ToList()

   private method CheckMatching(open as string, close as string) as logic
      return Array.IndexOf(self.TokensOpen, open) == Array.IndexOf(self.TokensClose, close)

   private method GetAutoCompleteScore(chunks as List<string>) as int64
      local res := 0 as int64
      self.GetMissingClosingTokens(chunks).Foreach({i => res := (res*5)+Array.IndexOf(self.TokensClose, i)+1 })
      return res

   protected override method Parse(data as List<string>) as void
      self.Data := data.Select({l => l.ToCharArray().Select({i => i.ToString()}).ToList()}).ToList()
      return

   protected override method Solve1() as object
      return self.Data.Select({i => self.GetSyntaxScore(i)}).Sum()

   protected override method Solve2() as object
      var s := self.Data.Where({i => self.GetSyntaxScore(i) == 0}).Select({i => self.GetAutoCompleteScore(i)}).OrderBy({i => i}).ToList()
      return s[(s.Count-1)/2]

end class