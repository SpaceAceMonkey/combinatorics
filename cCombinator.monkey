Strict

Import cCombinatoricsGenerator

' Generates combinations of elements from a given element pool. The number of elements
' in the pool must be less than 31. See NextValue() for a brief explanation.
Class Combinator<T> Extends CombinatoricsGenerator<T>
	Private
	' A bit pattern used to mask against items in the elements array.
	Field combinationBitPattern:Int
	' The maximum possible index. This is, in effect, another bit
	' pattern for combinationBitPattern to be tested against.
	Field maximumIndex:Int
	
	' Calculates a bit pattern that will be used by NextValue() to build
	' the next combination of elements.
	Method AdvancePointer:Void()
		Local leastSignificantBit:Int = combinationBitPattern & - combinationBitPattern
		Local wave:Int = combinationBitPattern + leastSignificantBit
		Local leastSignificantBitInWave:Int = wave & - wave
		Local additionalMask:Int = ( (leastSignificantBitInWave / leastSignificantBit) Shr 1) - 1
		combinationBitPattern = wave | additionalMask
		currentSeriesPosition += 1
	End Method

	Public
	' Initialize a new Combinator. Elements is an array of type T, and
	' groupSize is the number of elements to use in each combination.
	Method New()
		Throw New CombinatorConstructorArgumentsException()
	End Method
	
	Method New(_elements:T[], _groupSize:Int = 0)
		If (_elements.Length > 30)
			Throw New CombinatorElementsSizeException
		EndIf
		If (_groupSize < 0)
			Throw New CombinatorGroupSizeException()
		ElseIf(_groupSize = 0)
			_groupSize = _elements.Length
		ElseIf(_groupSize > _elements.Length)
			Throw New CombinatorGroupSizeException()
		EndIf

		groupSize = _groupSize
		elements = _elements
		length = Combinatorics.Choose(elements.Length, groupSize)
		maximumIndex = 1 Shl elements.Length

		Reset()
	End Method

	' Sets the initial bit pattern which will be used to select elements
	' from the elements array to form a combination. This functionality
	' is specific to the Combinator class. In general, Reset() should
	' put the current object into the same state it was in when it was
	' newly created.
	Method Reset:Void()
		combinationBitPattern = (1 Shl groupSize) - 1
		currentSeriesPosition = -1
		currentValue = New T[groupSize]
	End Method
	
	' Generates the next combination of elements, and returns it as
	' an array. Elements are selected from the elements array based
	' on the bits in combinationBitsPattern. For instance, a bit
	' pattern of ... 001111 would select the first four elements
	' from the array for use in the group. A bit pattern of
	' ... 00101011 would select the first, second, fourth, and
	' sixth elements from the elements array. This bit-fiddling
	' is why this generator can only work with element lists
	' containing less than thirty-one items.
	Method NextValue:T[] ()
		If (combinationBitPattern >= maximumIndex)
			Return NIL
		EndIf
		
		Local i:Int = 0
		Local j:Int = 0
		Local tmpIndex:Int = combinationBitPattern
		Local elementTransformAvailable:Bool = (nextElementTransform <> Null)
		Local valueTransformAvailable:Bool = (nextValueTransform <> Null)

		While (tmpIndex)
			If (tmpIndex & 1)
				If (elementTransformAvailable)
					currentValue[j] = nextElementTransform.Execute(elements[i])
				Else
					currentValue[j] = elements[i]
				EndIf
				j += 1
			EndIf

			tmpIndex = tmpIndex Shr 1
			i += 1
		Wend

		AdvancePointer()
		
		If (valueTransformAvailable)
			Return nextValueTransform.Execute(currentValue)[ ..]
		EndIf
		
		Return currentValue[ ..]
	End Method
	
	Method GetValueAtIndex:T[] (index:Int)
		If (index < 0 Or index > length - 1)
			Throw New CombinatorInvalidArgumentException()
		EndIf
		
		Local _combinationBitPattern:Int = combinationBitPattern
		Local _currentValue:T[] = currentValue[ ..]
		Local _currentSeriesPosition:Int = currentSeriesPosition
		
		Reset()
		
		For Local i:Int = 0 Until index
			AdvancePointer()
		Next
		
		Local result:T[] = NextValue()
		
		combinationBitPattern = _combinationBitPattern
		currentValue = _currentValue
		currentSeriesPosition = _currentSeriesPosition
		
		Return result
	End Method
	
	Method ToArray:T[][] ()
		Reset()
		Return Super.ToArray()
	End Method
End Class
