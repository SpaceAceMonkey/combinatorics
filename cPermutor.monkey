Strict

Import cCombinatoricsGenerator
Import cCombinator

' Generates permutations of elements from a given element pool.
Class Permutor<T> Extends CombinatoricsGenerator<T>
	Private
	Field combinator:Combinator<T>
	
	Public
	' Initialize a new Permutor. Elements is an array of type T, and
	' groupSize is the number of elements to use in each permutation.
	Method New()
		Throw New CombinatorConstructorArgumentsException()
	End Method
	
	Method New(_elements:T[])
		elements = _elements
		groupSize = elements.Length
		length = Combinatorics.PermutationsCount(elements.Length, groupSize)
		Reset()
		combinator = New Combinator<T>(elements, groupSize)
	End Method

	Method NextValue:T[] ()
		If (currentSeriesPosition >= length)
			Local emptyResult:T[]
			Return emptyResult
		EndIf
		
		Local digits:Int[] = Combinatorics.FactorialRadix(currentSeriesPosition, groupSize)
		Local _elements:T[] = elements[ ..]
		For Local i:Int = groupSize - 1 To 0 Step - 1
			currentValue[i] = _elements[digits[i]]
			For Local j:Int = digits[i] To _elements.Length - 2
				_elements[j] = _elements[j + 1]
			Next
		Next
		currentSeriesPosition += 1

		Return currentValue
	End Method
	
	' Reset the generator to its initial state.
	Method Reset:Void()
		currentSeriesPosition = 0
		currentValue = New T[groupSize]
		combinator = New Combinator<T>(elements, groupSize)
	End Method
End Class