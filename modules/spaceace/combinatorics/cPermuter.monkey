#Rem monkeydoc Module spaceace.combinatorics
(c) 2016-
Contact the author through the forums or via private messages at
http://www.monkey-x.com/, username SpaceAce.

You may use, modify, and re-distribute this code in any way you
see fit, as long as this notice remains intact, and you do not
collect any money for the source code. You may use this code
in both commercial and non-commercial projects.
#End

Strict

Import cCombinatoricsGenerator
Import cCombinator

#rem monkeydoc
	Generates permutations of elements from a given element pool.
	See comments in cCombinator.monkey for overviews of the
	interface methods.
#END
Class Permuter<T> Extends CombinatoricsGenerator<T>
	Public
	#rem monkeydoc
		Throws an exception if the user tries to create this generator
		without providing arguments to the constructor.
	#END
	Method New()
		Throw New CombinatorConstructorArgumentsException()
	End Method
	
	#rem monkeydoc
		Initialize a new permuter. Elements is an array of type T.
	#END
	Method New(_elements:T[])
		elements = _elements
		groupSize = elements.Length
		length = Combinatorics.PermutationsCount(elements.Length, groupSize)
		Reset()
	End Method

	#rem monkeydoc
		Generates and returns the next value in this generator's series
	#END
	Method NextValue:T[] ()
		If (currentSeriesPosition >= length - 1)
			Return NIL
		EndIf

		currentSeriesPosition += 1
		Local digits:Int[] = Combinatorics.FactorialRadix(currentSeriesPosition, groupSize)
		Local _elements:T[] = elements[ ..]
		Local elementTransformAvailable:Bool = (nextElementTransform <> Null)
		Local valueTransformAvailable:Bool = (nextValueTransform <> Null)

		For Local i:Int = groupSize - 1 To 0 Step - 1
			If (elementTransformAvailable)
				currentValue[i] = nextElementTransform.Execute(_elements[digits[i]])
			Else
				currentValue[i] = _elements[digits[i]]
			EndIf
			
			For Local j:Int = digits[i] To _elements.Length - 2
				_elements[j] = _elements[j + 1]
			Next
		Next

		If (valueTransformAvailable)
			Return nextValueTransform.Execute(currentValue)[ ..]
		EndIf
		
		Return currentValue[..]
	End Method
	
	#rem monkeydoc
		Resets the generator, and returns an array with every permutation
		in the generator's space.
	#END
	Method ToArray:T[][] ()
		Reset()
		Return Super.ToArray()
	End Method

	#rem monkeydoc
		Reset the generator to its initial state.
	#END
	Method Reset:Void()
		currentSeriesPosition = -1
		currentValue = New T[groupSize]
	End Method

	#rem monkeydoc
		Advance the generator's internal pointer until it reaches
		the desired position, then return the value at that position.
	#END
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