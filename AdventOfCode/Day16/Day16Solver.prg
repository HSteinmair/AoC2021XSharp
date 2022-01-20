using System
using System.Collections.Generic
using System.Text
using System.Linq

class Day16Solver inherit SolverBase

   private property Data as List<Packet> auto
   private property Bits as string auto

   private class Packet
      public property Version as int auto
      public property TypeID as int auto
      public property Val as int64 auto
      public property Packets as List<Packet> auto

      public property SumVersion as int get self.Version + self.Packets.Sum({i => i.SumVersion})

      public constructor(packetVersion as int, packetTypeID as int, packetValue as int64, packetPackets as List<Packet>)
         self.Version := packetVersion
         self.TypeID := packetTypeID
         self.Val := packetValue
         self.Packets := packetPackets
         return

      public method Eval() as int64
         switch self.TypeID
            case 0
               return self.Packets.Sum({i => i.Eval()})
            case 1
               local ret := 1L as int64
               self.Packets.ForEach({i => ret *= i.Eval()})
               return ret
            case 2
               return self.Packets.Min({i => i.Eval()})
            case 3
               return self.Packets.Max({i => i.Eval()})
            case 4
               return self.Val
            case 5
               return iif(self.Packets[0].Eval() > self.Packets[1].Eval(), 1L, 0L)
            case 6
               return iif(self.Packets[0].Eval() < self.Packets[1].Eval(), 1L, 0L)
            case 7
               return iif(self.Packets[0].Eval() == self.Packets[1].Eval(), 1L, 0L)
         end switch
         return 0L

   end class

   private method ParseBits(bits as string) as Tuple<Packet, int>
      var idx := 6
      var sub := List<Packet>{}
      var version := Convert.ToInt32(bits.Substring(0, 3), 2)
      var typeID := Convert.ToInt32(bits.Substring(3, 3), 2)
      if typeID == 4
         var grp := self.GetGroupsOf5(bits.SubString(idx))
         var literal := ""
         foreach var g in grp
            literal += g.Substring(1, 4)
            idx += 5
            if g[0] == '0'
         exit
            endif
         next
         var literalValue := Convert.ToInt64(literal, 2)
         return Tuple.Create(Packet{version, typeID, literalValue, List<Packet>{}}, idx)
      else
         var lenTypeID := Convert.ToInt32(bits.SubString(idx, 1), 2)
         idx += 1
         switch lenTypeID
            case 0
               var lengthSub := Convert.ToInt32(bits.Substring(idx, 15), 2)
               idx += 15
               do while lengthSub > 0
                  var tmp := self.ParseBits(bits.Substring(idx, lengthSub))
                  sub.Add(tmp.Item1)
                  lengthSub -= tmp.Item2
                  idx += tmp.Item2
               end do
            case 1
               var CountSub := Convert.ToInt32(bits.Substring(idx, 11), 2)
               idx += 11
               for var n := 1 upto CountSub
                  var tmp := self.ParseBits(bits.Substring(idx))
                  sub.Add(tmp.Item1)
                  idx += tmp.Item2
               next
         end switch
      endif
      return Tuple.Create(Packet{version, typeID, 0L, sub}, idx)

   private method GetGroupsOf5(val as string) as List<string>
      var ret := List<string>{}
      var pos := 0
      do while pos < val.Length-1
         if pos+5 < val.Length
            ret.Add(val.Substring(pos, 5))
         else
            ret.Add(val.Substring(pos))
         endif
         pos += 5
      end do
      return ret

   protected override method Parse(data as List<string>) as void
      self.Bits := string.Join("", data.First().Select({i => Convert.ToString(Convert.ToInt32(i.ToString(), 16), 2).PadLeft(4, '0')}))
      return

   protected override method Solve1() as object
      var tmp := self.ParseBits(self.Bits)
      return tmp.Item1.SumVersion

   protected override method Solve2() as object
      var tmp := self.ParseBits(self.Bits)
      return tmp.Item1.Eval()

end class