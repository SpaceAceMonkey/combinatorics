#Rem monkeydoc Module spaceace.combinatorics
#End

Strict

Import cCombinatoricsGenerator

#rem monkeydoc
	Generates combinations of elements from a given element pool. The number of elements
	in the pool must be less than 31. See NextValue() for a brief explanation.
#END
Class Combinator<T> Extends CombinatoricsGenerator<T>
	Private
	#rem monkeydoc
		A bit pattern used to mask against items in the elements array.
	#END
	Field combinationBitPattern:Int
	#rem monkeydoc
		The maximum possible index. This is, in effect, another bit
		pattern for combinationBitPattern to be tested against.
	#END
	Field maximumIndex:Int
	
	#rem monkeydoc
		Calculates a bit pattern that will be used by NextValue() to build
		the next combination of elements.
	#END
	Method AdvancePointer:Void()
		Local leastSignificantBit:Int = combinationBitPattern & - combinationBitPattern
		Local wave:Int = combinationBitPattern + leastSignificantBit
		Local leastSignificantBitInWave:Int = wave & - wave
		Local additionalMask:Int = ( (leastSignificantBitInWave / leastSignificantBit) Shr 1) - 1
		combinationBitPattern = wave | additionalMask
		currentSeriesPosition += 1
	End Method

	Public
	#rem monkeydoc
		Throws an exception if the user tries to instantiate
		this generator without providing the necessary 
		arguments.
	#END
	Method New()
		Throw New CombinatorConstructorArgumentsException()
	End Method
	
	#rem monkeydoc
		Initialize a new Combinator. Elements is an array of type T, and
		groupSize is the number of elements to use in each combination.
	#END
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

	#rem monkeydoc
		Sets the initial bit pattern which will be used to select elements
		from the elements array to form a combination. This functionality
		is specific to the Combinator class. In general, Reset() should
		put the current object into the same state it was in when it was
		newly created.
	#END
	Method Reset:Void()
		combinationBitPattern = (1 Shl groupSize) - 1
		currentSeriesPosition = -1
		currentValue = New T[groupSize]
	End Method
	
	#rem monkeydoc
		Generates the next combination of elements, and returns it as
		an array. Elements are selected from the elements array based
		on the bits in combinationBitsPattern. For instance, a bit
		pattern of ... 001111 would select the first four elements
		from the array for use in the group. A bit pattern of
		... 00101011 would select the first, second, fourth, and
		sixth elements from the elements array. This bit-fiddling
		is why this generator can only work with element lists
		containing less than thirty-one items.
	#END
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
	
	#rem monkeydoc
		Advances the internal pointer to the desired location
		without generating the intervening combinations. This
		is much faster than using ToArray().
	#END
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
	
	#rem monkeydoc
		Resets the generator, and returns an array with every combination
		in the generator's space.
	#END
	Method ToArray:T[][] ()
		Reset()
		Return Super.ToArray()
	End Method
End Class
