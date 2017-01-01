Strict

#rem monkeydoc
	This class provides math functions to aid in
	the generation of combinations and permutations.
	All member functions of this class are static,
	and do not require you to instantiate the class
	before use.
#END
Class Combinatorics
	#rem monkeydoc
		Permutation count
		from Permutations permute = fPp = from! / (from - permute)!
	#END
	Function PermutationsCount:Int(from:Int, permute:Int)
		Local result:Int = 1
		While (permute > 0)
			result *= from
			permute -= 1
			from -= 1
		Wend
		
		Return result
	End Function
	
	#rem monkeydoc
		Combination count
		from Choose choose = fCc = from! / ((from-choose)! * choose!)
	#END
	Function Choose:Int(from:Int, choose:Int)
		If (choose > from)
			Return 0
		EndIf
		
		Local result:Int = PermutationsCount(from, choose) / Factorial(choose)
		
		Return result
	End Function
	
	#rem monkeydoc
		Calculates the number of permutations of elements in groups
		sized from one to elements.Length.
	#END
	Function MassPermutationsCount:Int(numberOfElements:Int)
		Local result:Int = 0
		For Local i:Int = 1 To numberOfElements
			Local permutations:Int = PermutationsCount(numberOfElements, i)
			result += permutations
		Next
		
		Return result
	End Function
	
	#rem monkeydoc
		Calculates number!
	#END
	Function Factorial:Int(number:Int)
		Local result:Int
		result = PermutationsCount(number, number)
		
		Return result
	End Function
	
	#rem monkeydoc
		Convert number into a varying-base representation. In general,
		FactorialRadix(number, places) =
		x * (places)! + y * (places - 1)! + z * (places - 2)! ...
		
		The result always ends with 0 * 0! and the array is orderd
		from least-significant place, to most-significant place.
		
		Examples:
		FactorialRadix(6, 4) =
		0 * 4! + 1 * 3! + 0 * 2! + 0 * 1! + 0 * 0! =
		[0, 0, 0, 1, 0]
		FactorialRadix(22, 6) =
		0 * 6! + 0 * 5! + 0 * 4! + 3 * 3! + 2 * 2! + 0 * 1! + 0 * 0! =
		[0, 0, 2, 3, 0, 0, 0]
		FactorialRadix(800, 6) =
		1 * 6! + 0 * 5! + 3 * 4! + 1 * 3! + 1 * 2! + 0 * 1! + 0 * 0! =
		[0, 0, 1, 1, 3, 0, 1]
		FactorialRadix(2, 2) =
		1 * 2! + 0 * 1! + 0 * 0! =
		[0, 0, 1]
		
		Returns an array of integers representing the multiplier at each
		position.
	#END
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
