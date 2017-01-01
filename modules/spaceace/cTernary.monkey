Class Ternary<T>
	Function Eval:T(expression:Bool, trueValue:T, falseValue:T)
		Local result:T

		If (expression)
			result = trueValue
		Else
			result = falseValue
		EndIf
	
		Return result
	End Function
End Class
