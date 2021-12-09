using System
using System.Collections.Generic
using System.Text
using System.IO
using System.Linq


class SolverConsoleRummer<T> where T is SolverBase, new()

   private Solver as T
   private InputFile as string
   private WithInputFileOtion as logic


   constructor(addInputFileOption := false as logic)
      self:Solver := T{}
      self:InputFile := "input.txt"
      self:WithInputFileOtion := addInputFileOption
      return


   method PrintResult(nr as int, output as string) as void
      if !string.isNullOrEmpty(output)
         Console.WriteLine(ie"Result of Puzzle {nr}: {output}")
      else
         Console.WriteLine(ie"No Result of Puzzle {nr}")
      endif
      Console.WriteLine("")
      return


   method CheckInputFile as logic
      var fileName := Path.Combine(self:Solver.DayDirectory, self:InputFile)
      if !File.Exists(fileName)
         File.WriteAllText(fileName, "")
      endif
      if FileInfo{fileName}.Length <= 3
         Console.WriteLine("Input file is still empty. Opening it in the default editor. Copy the puzzle input from the website into the editor")
         Console.WriteLine("")
         System.Diagnostics.Process.Start(fileName)
         return false
      end if
      return true

   public method Run() as void
      Console.WriteLine("Running Solver " + self:solver.GetType().Name)
      Console.WriteLine("")
      if WithInputFileOtion
         Console.WriteLine("Use test-data y/n?")
         var testData := Console.ReadLine()
         if testData == "y"
            self:InputFile := "TestData.txt"
         endif
      endif
      if self:CheckInputFile()
         self:PrintResult(1, self:solver.ExecutePuzzle1(self:InputFile))
         self:PrintResult(2, self:solver.ExecutePuzzle2(self:InputFile))
      end if
      Console.WriteLine("Press any key to exit")
      Console.ReadKey()
      return

end class

