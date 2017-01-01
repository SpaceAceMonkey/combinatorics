Strict

Import cCombinator
Import cPermuter
Import cCombinatorPermuter
Import cMassPermuter
Import mojo
Import cTernary

Function Main:Int()
	Local date:Int[] = GetDate()
	Seed = date[5] | date[6]

	Local aString:String = "abcdefgh"
	Local numberToChoose:Int = 6

'	TestCombinator(aString, numberToChoose)

	aString = "abcd"
'	TestPermuter(aString)
	
	aString = "abcdef"
	numberToChoose = 2
'	TestCombinatorPermuter(aString, numberToChoose)
	
	aString = "ab"
	TestMassPermuter(aString)
	
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
	Print "Last generated value = " + Implode(ic.GetCurrentValue()) + "."
	Print ""
	ShowResultsBlock(ic, 40)
	Print ""

	Print "---- To[Array|Stack|List]() tests ----"
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
	Print ""

	Print "---- Value getter tests ----"
	Print "Resetting and generating array."
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
	Print ""
	
	TestNextElementTransform(ic)
	TestNextValueTransform(ic)
	Print ""
End Function

Function TestPermuter:Void(aString:String)
	Local elements:String[] = aString.Split("")

	Print "======== Testing permuter ========"
	Local ip:Permuter<String> = New Permuter<String>(elements)
	Print "There are " + ip.Length() + " permutations of " + elements.Length + " items."
	Local halfway:Int = ip.Length() / 2
	Local milliseconds:Int = Millisecs()
	Local tmpValue:String[]
	While (ip.NextValue())
		If (ip.GetCurrentSeriesPosition() = halfway)
			tmpValue = ip.GetCurrentValue()
		EndIf
	Wend
	Print "Series generated in " + (Millisecs() -milliseconds) + " milliseconds."
	Print "First generated value = " + Implode(ip.GetValueAtIndex(0))
	Print "Half-way value via NextValue() = " + Implode(tmpValue)
	Print "Half-way value via GetValueAtIndex() = " + Implode(ip.GetValueAtIndex(halfway))
	Print ""

	Print ""
	ShowResultsBlock(ip, 40)
	Print ""
	
	Print "---- To[Array|Stack|List]() tests ----"
	Print "Resetting and generating array."
	milliseconds = Millisecs()
	Local arrayResult:String[][] = ip.ToArray()
	Print "Array of length " + arrayResult.Length + " generated in " + (Millisecs() -milliseconds) + " milliseconds."
	Print "Half-way value in array = " + Implode(arrayResult[halfway])
	Print ""
	
	TestNextElementTransform(ip)
	TestNextValueTransform(ip)
	Print ""
End Function

Function TestCombinatorPermuter:Void(aString:String, numberToChoose:Int)
	Local elements:String[] = aString.Split("")
	Local ic:CombinatorPermuter<String> = New CombinatorPermuter<String>(elements, numberToChoose)

	Print "======== Testing Combinator/permuter ========"
	Print "Generating entire series of " + ic.Length() + " combinations."
	Local milliseconds:Int = Millisecs()
	While (ic.NextValue())
	Wend
	Print "Series generated in " + (Millisecs() -milliseconds) + " milliseconds."
	Print "Last generated value = " + Implode(ic.GetCurrentValue()) + "."
	Print ""
	ShowResultsBlock(ic, 40)
	Print ""

	Print "---- To[Array|Stack|List]() tests ----"
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
	Print ""

	Print "---- Value getter tests ----"
	Print "Resetting and generating array."
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
	Print ""
	
	TestNextElementTransform(ic)
	TestNextValueTransform(ic)
	Print ""
End Function

Function TestMassPermuter:Void(aString:String)
	Local elements:String[] = aString.Split("")
	Local ic:MassPermuter<String> = New MassPermuter<String>(elements)

	Print "======== Testing mass permuter ========"
	Print "Generating entire series of " + ic.Length() + " combinations."
	Local milliseconds:Int = Millisecs()
	Print "Series generated in " + (Millisecs() -milliseconds) + " milliseconds."
	Print "Last generated value = " + Implode(ic.GetCurrentValue()) + "."
	Print ""
	ShowResultsBlock(ic, 40)
	Print ""

Print "Index test"
	Print Implode(ic.GetValueAtIndex(0))
	Print Implode(ic.GetValueAtIndex(1))
	Print "======== Trouble indexes start now ========"
	Print Implode(ic.GetValueAtIndex(2))
	Print Implode(ic.GetValueAtIndex(3))
	#rem
	Print "---- To[Array|Stack|List]() tests ----"
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
	Print ""

	Print "---- Value getter tests ----"
	Print "Resetting and generating array."
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
	Print ""
	
	TestNextElementTransform(ic)
	TestNextValueTransform(ic)
	Print ""
#end
End Function

Function TestNextElementTransform:Void(g:ICombinatoricsGenerator<String>)
	Print "---- Element transformation tests ----"
	Print "Testing NextElementTransform."
	Print "Before filter:"
	Local targetIndex:Int = Rnd(g.Length())
	Print targetIndex + ": " + Implode(g.GetValueAtIndex(targetIndex))
	Local nextElementTransform:NextElementTransform<String> = New NextElementTransform<String>()
	g.SetNextElementTransform(nextElementTransform)
	Print "After filter:"
	Print targetIndex + ": " + Implode(g.GetValueAtIndex(targetIndex))
	g.SetNextElementTransform(Null)
	Print "After after filter:"
	Print targetIndex + ": " + Implode(g.GetValueAtIndex(targetIndex))
	Print ""
End Function

Function TestNextValueTransform:Void(g:ICombinatoricsGenerator<String>)
	Print "---- Group transformation tests ----"
	Print "Testing NextValueTransform."
	Print "Before filter:"
	Local targetIndex% = Rnd(g.Length())
	Print targetIndex + ": " + Implode(g.GetValueAtIndex(targetIndex))
	Local nextValueTransform:NextValueTransform<String[] > = New NextValueTransform<String[] > ()
	g.SetNextValueTransform(nextValueTransform)
	Print "After filter:"
	Print targetIndex + ": " + Implode(g.GetValueAtIndex(targetIndex))
	g.SetNextValueTransform(Null)
	Print "After after filter:"
	Print targetIndex + ": " + Implode(g.GetValueAtIndex(targetIndex))
	Print ""
End Function

Function ShowResultsBlock:Void(g:ICombinatoricsGenerator<String>, limit:Int = 40)
	Local toShow:Int = Min(g.Length(), limit)
	Print "---- Showing " + toShow + " of " + g.Length() + " groupings ----"
	Local seriesStack:Stack<String[] > = New Stack<String[] > (g.ToArray())
	Local i:Int = 0
	While (i < toShow)
		Local j:Int = 0
		Local stringStack:StringStack = New StringStack()
		While (j < 4 And seriesStack.Length() > 0)
			stringStack.Push("[" + Implode(seriesStack.Pop(), ", ") + "]")
			j += 1
			i += 1
		Wend
		Print Implode(stringStack.ToArray(), ", ")
	Wend
End Function

Class NextElementTransform<T> Implements ICombinatorCallback<T>
	Method Execute:T(value:T)
		Local result:T
		result = value + value
		
		Return result
	End Method
End Class

Class NextValueTransform<T> Implements ICombinatorCallback<T>
	Method Execute:T(value:T)
		For Local v:Int = 0 To value.Length - 1
			value[v] = "s"
		Next
		
		Return value
	End Method
End Class
	
Function Implode:String(arr:String[], seperator:String = "")
	Local s:String
	For Local i:Int = 0 To arr.Length - 1
		s += arr[i]
		If (i < arr.Length - 1)
			s += seperator
		EndIf
	Next
	
	Return s
End Function

Function Implode:String(arr:Int[], seperator:String = "")
	Local s:String
	For Local i:Int = 0 To arr.Length - 1
		s += arr[i]
		If (i < arr.Length - 1)
			s += seperator
		EndIf
	Next
	
	Return s
End Function

