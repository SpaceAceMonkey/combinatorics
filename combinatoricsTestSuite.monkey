Strict

Import cCombinator
Import cPermutor
Import mojo
Import cTernary

Function Main:Int()
	Local date:Int[] = GetDate()
	Seed = date[5] | date[6]

	Local aString:String = "abcdefgh"
	Local numberToChoose:Int = 4

	TestCombinator(aString, numberToChoose)

	aString = "abcdefgh"
	TestPermutor(aString)
	

	Return 0
End Function

Function TestCombinator:Void(aString:String, numberToChoose:Int)
	Local elements:String[] = aString.Split("")
	Local ic:Combinator<String> = New Combinator<String>(elements, numberToChoose)

	Print "======== Testing Combinator ========"
	Print "Generating entire series of " + ic.Length() + " combinations."
	Local milliseconds:Int = Millisecs()
	While (ic.NextValue())
	Wend
	Print "Series generated in " + (Millisecs() -milliseconds) + " milliseconds."
	Print "Last generated value = " + Implode(ic.GetGetCurrentValue()) + "."

	Print "Resetting and generating array."
	milliseconds = Millisecs()
	Local arrayResult:String[][] = ic.ToArray()
	Print "Array of length " + arrayResult.Length + " generated in " + (Millisecs() -milliseconds) + " milliseconds."

	Print "Resetting and generating stack."
	milliseconds = Millisecs()
	Local stackResult:Stack<String[] > = ic.ToStack()
	Print "Stack of length " + stackResult.Length + " generated in " + (Millisecs() -milliseconds) + " milliseconds."

	Print "Resetting and generating list."
	milliseconds = Millisecs()
	Local listResult:List<String[] > = ic.ToList()
	Print "List of length " + listResult.Count() + " generated in " + (Millisecs() -milliseconds) + " milliseconds."

	'
	Print "Checking GetValueAtIndex."
	Local targetIndex:Int = Rnd(ic.Length())
	milliseconds = Millisecs()
	Local valueAtIndex:String[] = ic.GetValueAtIndex(targetIndex)
	Print "Value at index " + targetIndex + " fetched in " + (Millisecs() -milliseconds) + " milliseconds."
	Print "Value at index " + targetIndex + " in array result: " + Implode(arrayResult[targetIndex])
	Print "GetValueAtIndex(" + targetIndex + ") result: " + Implode(valueAtIndex)
	If (Implode(arrayResult[targetIndex]) = Implode(valueAtIndex))
		Print "They match!"
	Else
		Print "Oh, no! They do not match. Something is wrong."
	EndIf

	Print "Testing NextValueFilter."
	Print "Before filter:"
	targetIndex = Rnd(ic.Length())
	Print targetIndex + ": " + Implode(arrayResult[targetIndex])
	Local nextValueFilter:NextValueFilter<String> = New NextValueFilter<String>()
	ic.SetNextValueFilter(nextValueFilter)
	Print "After filter:"
	Print targetIndex + ": " + Implode(ic.GetValueAtIndex(targetIndex))
	ic.SetNextValueFilter(Null)
	Print "After after filter:"
	Print targetIndex + ": " + Implode(ic.GetValueAtIndex(targetIndex))
End Function

Function TestPermutor:Void(aString:String)
	Local elements:String[] = aString.Split("")

	Print "======== Testing Permutor ========"
	Local ip:Permutor<String> = New Permutor<String>(elements)
	Print "There are " + ip.Length() + " permutations of " + elements.Length + " items."
	Local halfway:Int = ip.Length() / 2
	Local milliseconds:Int = Millisecs()
	Local tmpValue:String[]
	While (ip.NextValue())
		If (ip.GetCurrentSeriesPosition() = halfway)
			tmpValue = ip.GetGetCurrentValue()
		EndIf
	Wend
	Print "Series generated in " + (Millisecs() -milliseconds) + " milliseconds."
	Print "First generated value = " + Implode(ip.GetValueAtIndex(0))
	Print "Half-way value via NextValue() = " + Implode(tmpValue)
	Print "Half-way value via GetValueAtIndex() = " + Implode(ip.GetValueAtIndex(halfway))
	'	Print "Last generated value = " + Implode(ip.GetGetCurrentValue()) + "."

	Print "Resetting and generating array."
	milliseconds = Millisecs()
	Local arrayResult:String[][] = ip.ToArray()
	Print "Array of length " + arrayResult.Length + " generated in " + (Millisecs() -milliseconds) + " milliseconds."
	Print "Half-way value in array = " + Implode(arrayResult[halfway])
End Function






Class NextValueFilter<T> Implements ICombinatorCallback<T>
	Method Execute:T(value:T)
		Local result:T
		result = value + value
		
		Return result
	End Method
End Class
	
Function Implode:String(arr:String[])
	Local s:String
	For Local element:String = EachIn(arr)
		s += element
	Next
	
	Return s
End Function
Function Implode:String(arr:Int[])
	Local s:String
	For Local element:String = EachIn(arr)
		s += element
	Next
	
	Return s
End Function

