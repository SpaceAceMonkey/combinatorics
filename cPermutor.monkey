Strict

Import cCombinatoricsGenerator
Import cCombinator

' Generates permutations of elements from a given element pool.
' See comments in cCombinator.monkey for overviews of the
' interface methods.
Class Permutor<T> Extends CombinatoricsGenerator<T>
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
	End Method

	Method NextValue:T[] ()
		If (currentSeriesPosition >= length - 1)
			Local emptyResult:T[]
			Return emptyResult
		EndIf

		currentSeriesPosition += 1
		Local digits:Int[] = Combinatorics.FactorialRadix(currentSeriesPosition, groupSize)
		Local _elements:T[] = elements[ ..]
		Local filterAvailable:Bool = (nextValueFilter <> Null)

		For Local i:Int = groupSize - 1 To 0 Step - 1
			If (filterAvailable)
				currentValue[i] = nextValueFilter.Execute(_elements[digits[i]])
			Else
				currentValue[i] = _elements[digits[i]]
			EndIf
			
			For Local j:Int = digits[i] To _elements.Length - 2
				_elements[j] = _elements[j + 1]
			Next
		Next

		Return currentValue[..]
	End Method
	
	Method ToArray:T[][] ()
		Reset()
		Return Super.ToArray()
	End Method

	' Reset the generator to its initial state.
	Method Reset:Void()
		currentSeriesPosition = -1
		currentValue = New T[groupSize]
	End Method

	Method GetValueAtIndex:T[] (index:Int)
		If (index < 0 Or index > length - 1)
			Throw New CombinatorInvalidArgumentException()
		EndIf

		Local _currentValue:T[] = currentValue[ ..]
		Local _currentSeriesPosition:Int = currentSeriesPosition

		currentSeriesPosition = index - 1
		Local result:T[] = NextValue()

		currentValue = _currentValue
		currentSeriesPosition = _currentSeriesPosition
				
		Return result
	End Method
End Class