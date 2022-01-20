using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day14Solver inherit SolverBase

   private property Data as Dictionary<string,string> auto
   private property PairCnt as Dictionary<string,int64> auto
   private property LetterCnt as Dictionary<char,int64> auto

   private method PerformInsertions(steps as int) as void
      for var step := 1 upto steps
         var pairs := self.PairCnt.Select({i => i.Key}).ToList()
         var tmp := self.PairCnt.ToDictionary({i => i.Key}, {i => i.Value})
         foreach var pair in pairs
            if self.Data.TryGetValue(pair, out var ins)
               var cnt := tmp[pair]
               self.IncrementPairCnt(pair[0].ToString()+ins, cnt)
               self.IncrementPairCnt(ins+pair[1].ToString(), cnt)
               self.IncrementPairCnt(pair, cnt*(-1L))
               self.LetterCnt[ins[0]] += cnt
            endif
         next
      next
      return

   private method GetMaxMinusMinLetterCnt() as int64
      var cnts := self.LetterCnt.Where({i => i.Value > 0L}).Select({i => i.Value}).ToList()
      return cnts.Max()-cnts.Min()

   private method IncrementPairCnt(pair as string, cnt as int64) as void
      if !self.PairCnt.ContainsKey(pair)
         self.PairCnt.Add(pair, 0L)
      endif
      self.PairCnt[pair] += cnt
      return

   private method InitPolymere(polymere as string) as void
      self.LetterCnt := "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToDictionary({i => i}, {i => (int64)0L})
      polymere.ToList().ForEach({i => self.LetterCnt[i]++})
      self.PairCnt := Dictionary<string,int64>{}
      for var pos := 0 upto polymere.Length-2
         self.IncrementPairCnt(polymere.SubString(pos, 2), 1L)
      next
      return

   protected override method Parse(data as List<string>) as void
      self.Data := data.Where({i, index => index > 1}).ToDictionary({i => i.Substring(0, 2)}, {i => i.Substring(i.Length-1)})
      self.InitPolymere(data.FirstOrDefault())
      return

   protected override method Solve1() as object
      self.PerformInsertions(10)
      return self.GetMaxMinusMinLetterCnt()

   protected override method Solve2() as object
      self.PerformInsertions(40)
      return self.GetMaxMinusMinLetterCnt()

end class