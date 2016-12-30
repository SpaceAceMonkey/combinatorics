Strict

Class Combinatorics
	' Permutation count
	' from Permutations permute = fPp = from! / (from - permute)!
	Function PermutationsCount:Int(from:Int, permute:Int)
		Local result:Int = 1
		While (permute > 0)
			result *= from
			permute -= 1
			from -= 1
		Wend
		
		Return result
	End Function
	
	' Combination count
	' from Choose choose = fCc = from! / ((from-choose)! * choose!)
	Function Choose:Int(from:Int, choose:Int)
		If (choose > from)
			Return 0
		EndIf
		
		Local result:Int = PermutationsCount(from, choose) / Factorial(choose)
		
		Return result
	End Function
	
	' Calculates number!
	Function Factorial:Int(number:Int)
		Local result:Int
		result = PermutationsCount(number, number)
		
		Return result
	End Function
	
	' Convert number into a varying-base representation. In general,
	' FactorialRadix(number, places) =
	' x * (places)! + y * (places - 1)! + z * (places - 2)! ...
	'
	' Examples:
	' FactorialRadix(6, 4) =
	' 0 * 4! + 1 * 3! + 0 * 2! + 0 * 1! + 0 * 0!
	' FactorialRadix(22, 6) =
	' 0 * 6! + 0 * 5! + 0 * 4! + 3 * 3! + 2 * 2! + 0 * 1!
	' FactorialRadix(800, 6) =
	' 1 * 6! + 0 * 5! + 3 * 4! + 1 * 3! + 1 * 2! + 0 * 1!
	' FactorialRadix(2, 2) =
	' 1 * 2! + 0 * 1!
	'
	' Returns an array of integers representing the multiplier at each
	' position. For the example of FactorialRadix(800, 6) above, the
	' resulting array would be [1, 0, 3, 1, 1, 0].
	Function FactorialRadix:Int[] (number:Int, places:Int = 0)
		Local factor:Int = 1
		If Not (places)
			places = 0
			While (factor < number)
				places += 1
				factor *= places
			Wend
			
			If (factor > number)
				factor /= places
				places -= 1
			EndIf
		Else
			factor = Factorial(places)
		EndIf
		
		Local result:Int[places + 1]
		result[0] = 0
		While (places)
			result[places] = Floor(number / factor)
			number = number Mod factor
			factor /= places
			places -= 1
		Wend
		
		Return result
	End Function
End Class
