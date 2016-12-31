Import iCombinatorCallback

Interface ICombinatoricsGenerator<T>
	''''
	''''	Generation methods
	''''
	' Generate and return next combination, permutation, or whatever.
	Method NextValue:T[] ()
	' Return the result of the last call to NextValue. This is useful,
	' for example, for calling NextValue() inside a loop evaluation, 
	' then retrieving the value from inside the loop.
	' This may disappear from the interface definition in the future.
	' I haven't decided if it's worth requiring.
	Method GetCurrentValue:T()
	' Resets the internal pointer so that the series will be generated
	' starting from the beginning on the next call to NextValue().
	Method Reset:Void()
	
	''''
	''''	Information methods
	''''
	' How many combinations/permutations exist in the generator's space
	Method Length:Int()
	' Return an integer in the range 0 ... Length()-1 representing where
	' in the current series the last generated value falls.
	Method GetCurrentSeriesPosition%()
	
	''''
	''''	Retrieval methods
	''''
	' Fetch an item by its position in the series. Internal pointers and
	' value stores should be returned to their pre-GetByIndex() state
	' after GetByIndex() executes, so as to not interrupt an in-progress
	' series.
	Method GetValueAtIndex:T[](index:Int)
	' Return all values as an array
	Method ToArray:T[] ()
	
	''''
	''''	Data manipulation methods
	''''
	' Set an ICombinatorCallback which will be executed on every call to NextValue().
	' The value returned from NextValue() will be passed to the ICombinatorCallback's
	' Execute() method. The T value returned from Execute() will be used in place of
	' the original value when building the current combination.
	Method SetNextValueFilter:Void(callback:ICombinatorCallback<T>)
End Interface
