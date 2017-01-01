Strict

Import cCombinatoricsGenerator
Import cCombinatorPermuter

#rem monkeydoc
#END
#rem monkeydoc
	Generates all permutations of all combinations of
	all sizes from groupSize down to one.
#END
Class MassPermuter<T> Extends CombinatoricsGenerator<T>
	Private
	Field combinator:Combinator<T>
	Field permuter:Permuter<T>
	
	#rem monkeydoc
		Apply nextElementTransform.Execute() to a single element
		before the generator uses that element in a grouping.
		Since this is an array, it will be modified in place. We
		don't need to return it when we are done with it.
	#END
	Method ApplyElementTransform:Void(result:T[])
		For Local i:Int = 0 To result.Length - 1
			result[i] = nextElementTransform.Execute(result[i])
		Next
	End Method
	
	#rem monkeydoc
		Apply nextValueTransform.Execute() to the current grouping
		as a whole. Since this is an array, it will be modified in
		place. We don't need to return it when we are done with it.
	#END
	Method ApplyValueTransform:Void(result:T[])
		For Local i:Int = 0 To result.Length - 1
			result = nextValueTransform.Execute(result)
		Next
	End Method
	
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

		Reset()
	End Method

	#rem monkeydoc
		Generates and returns the next value in this generator's series
	#END
	Method NextValue:T[] ()
		Local result:T[] = permuter.NextValue()
		If Not (result)
			Local nextCombo:T[] = combinator.NextValue()
			If Not (nextCombo)
				groupSize -= 1
				If (groupSize < 1)
					Return NIL
				EndIf
				combinator = New Combinator<T>(elements, groupSize)
				nextCombo = combinator.NextValue()
				If Not (nextCombo)
					Return NIL
				EndIf
			EndIf
			permuter = New Permuter<T>(nextCombo)
			
			Return NextValue()
		EndIf
		
		Local elementTransformAvailable:Bool = (nextElementTransform <> Null)
		Local valueTransformAvailable:Bool = (nextValueTransform <> Null)

		If (elementTransformAvailable)
			ApplyElementTransform(result)
		EndIf

		If (valueTransformAvailable)
			ApplyValueTransform(result)
		EndIf

		currentValue = result[ ..]

		Return currentValue[ ..]
	End Method

	#rem monkeydoc
		Advance through this generator's space to retrieve the 
		value at a specific point in the series. This method
		may need to create multiple generators in order to
		find the one that holds the desired index, but it 
		only creates those generators and uses their lengths
		to find the index it is looking for. The values 
		between 0 and index are not generated, so this is
		still much faster than doing something like 
		ToArray()[index].
	#END
	Method GetValueAtIndex:T[] (index:Int)
		Local _groupSize:Int = groupSize
		groupSize = elements.Length
		Local _permuter:Permuter<T>
		Local elapsed:Int
		While (_groupSize > 0 And elapsed <= index)
			Local _combinator:Combinator<T> = New Combinator<T>(elements, groupSize)
			While (_combinator.NextValue() And elapsed <= index)
				_permuter = New Permuter<T>(_combinator.GetCurrentValue())
				elapsed += _permuter.Length()
			Wend

			groupSize -= 1
		Wend
		
		groupSize = _groupSize

		Local indexToPull:Int = _permuter.Length() - (elapsed - index)
		Local result:T[] = _permuter.GetValueAtIndex(indexToPull)

		Local elementTransformAvailable:Bool = (nextElementTransform <> Null)
		Local valueTransformAvailable:Bool = (nextValueTransform <> Null)

		If (elementTransformAvailable)
			ApplyElementTransform(result)
		EndIf

		If (valueTransformAvailable)
			ApplyValueTransform(result)
		EndIf

		Return result
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
		groupSize = elements.Length
		length = Combinatorics.MassPermutationsCount(elements.Length)
		combinator = New Combinator<T>(elements, groupSize)
		permuter = New Permuter<T>(combinator.NextValue())
	End Method
	
	#rem monkeydoc
		Return this generator's internal Permuter. This 
		is useful is you want to apply a value transform
		at the Permuter level, or wish to access the
		Permuter's series directly.
	#END
	Method GetPermuter:Permuter<T>()
		Return permuter
	End Method
	
	#rem monkeydoc
		Return this generator's internal Combinator. This
		is useful is you want to apply a value transform
		at the Combinator level, or wish to access the
		Combinator's series directly.
	#END
	Method GetCombinator:Combinator<T>()
		Return combinator
	End Method
End Class