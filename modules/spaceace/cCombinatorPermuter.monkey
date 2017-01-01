Strict

Import cCombinatoricsGenerator
Import cCombinator
Import cPermuter

#rem monkeydoc
	Generates combinations of groupSize elements, and from those
	combinations, generates all possible permutations.
#END
Class CombinatorPermuter<T> Extends CombinatoricsGenerator<T>
	Private
	Field combinator:Combinator < T >
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
		Initialize a new CombinatorPermuter; _elements 
		is an array of type T, and _groupSize is how
		many elements you want to use per permutation.
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
		length = Combinatorics.PermutationsCount(elements.Length, groupSize)
		
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
				Return NIL
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

		currentValue = result
		
		Return currentValue[ ..]
	End Method

	#rem monkeydoc
		Return this generator's internal Combinator. This
		is useful is you want to apply a value transform
		at the Combinator level, or wish to access the
		Combinator's series directly.
	#END
	Method Combinator:Combinator()
		Return combinator
	End Method
	
	#rem monkeydoc
		Return this generator's internal Permuter. This
		is useful is you want to apply a value transform
		at the Permuter level, or wish to access the
		Permuter's series directly.
	#END
	Method Permuter:Permuter()
		Return permuter
	End Method
	
	#rem monkeydoc
		Calculates which combination and permutation of that
		combination contains the desired index, then returns
		the value at that position. This is much faster 
		than iterating or using ToArray() on sizeable data
		sets, as intermediate values are not calculated.
	#END
	Method GetValueAtIndex:T[] (index:Int)
		Local combinationNumber:Int = index / permuter.Length()
		Local permutationNumber:Int = index Mod permuter.Length()

		Local elementTransformAvailable:Bool = (nextElementTransform <> Null)
		Local valueTransformAvailable:Bool = (nextValueTransform <> Null)

		Local result:T[] = New Permuter < T > (combinator.GetValueAtIndex(combinationNumber)).GetValueAtIndex(permutationNumber)

		If (elementTransformAvailable)
			ApplyElementTransform(result)
		EndIf

		If (valueTransformAvailable)
			ApplyValueTransform(result)
		EndIf

		Return result
	End Method
	
	#rem monkeydoc
		Reset the generator to its initial state.
	#END
	Method Reset:Void()
		combinator = New Combinator<T>(elements, groupSize)
		permuter = New Permuter<T>(combinator.NextValue())
		currentSeriesPosition = -1
		currentValue = New T[groupSize]
	End Method

	#rem monkeydoc
		Resets the generator, and returns an array with every permutation
		in the generator's space.
	#END
	Method ToArray:T[][] ()
		Reset()
		
		Return Super.ToArray()
	End Method
End Class