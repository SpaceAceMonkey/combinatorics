Import iCombinatorCallback

#rem monkeydoc
	This interface defines methods that must be implemented
	by any combinatorics generator in this module, or that
	wants to be compatible with the generators in this 
	module. Although interfaces are intended to be 
	implementation-agnostic, I have included comments for
	each method to give an overview of how they are used
	by the classes in this module.
#END
Interface ICombinatoricsGenerator<T>
	''''
	''''	Generation methods
	''''
	#rem monkeydoc
		Generate and return next combination, permutation, or whatever.
	#END
	Method NextValue:T[] ()
	#rem monkeydoc
		Return the result of the last call to NextValue. This is useful,
		for example, for calling NextValue() inside a loop evaluation,
		then retrieving the value from inside the loop.
		This may disappear from the interface definition in the future.
		I haven't decided if it's worth requiring.
	#END
	Method GetCurrentValue:T()
	#rem monkeydoc
		Resets the internal pointer so that the series will be generated
		starting from the beginning on the next call to NextValue().
	#END
	Method Reset:Void()
	
	''''
	''''	Information methods
	''''
	#rem monkeydoc
		How many combinations/permutations exist in the generator's space
	#END
	Method Length:Int()
	#rem monkeydoc
		Return an integer in the range 0 ... Length()-1 representing where
		in the current series the last generated value falls.
	#END
	Method GetCurrentSeriesPosition%()
	
	''''
	''''	Retrieval methods
	''''
	#rem monkeydoc
		Fetch an item by its position in the series. Internal pointers and
		value stores should be returned to their pre-GetByIndex() state
		after GetByIndex() executes, so as to not interrupt an in-progress
		series.
	#END
	Method GetValueAtIndex:T[](index:Int)
	#rem monkeydoc
		Return all values as an array
	#END
	Method ToArray:T[][] ()
	
	''''
	''''	Data manipulation methods
	''''
	#rem monkeydoc
		Set an ICombinatorCallback which will be executed on every call to NextValue().
		The value returned from NextValue() will be passed to the ICombinatorCallback's
		Execute() method. The T[] value returned from Execute() will be
		returned from NextValue().
	#END
	Method SetNextValueTransform:Void(callback:ICombinatorCallback<T[]>)
	#rem monkeydoc
		Set an ICombinatorCallback which will be executed on each element as it is
		selected for inclusion in a combination of permutation.
	#END
	Method SetNextElementTransform:Void(callback:ICombinatorCallback<T>)
End Interface
