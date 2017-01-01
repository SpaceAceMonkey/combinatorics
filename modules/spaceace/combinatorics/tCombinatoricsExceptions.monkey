#Rem monkeydoc Module spaceace.combinatorics
(c) 2016-
Contact the author through the forums or via private messages at
http://www.monkey-x.com/, username SpaceAce.

You may use, modify, and re-distribute this code in any way you
see fit, as long as this notice remains intact, and you do not
collect any money for the source code. You may use this code
in both commercial and non-commercial projects.
#End

#rem monkeydoc
	To be thrown when an invalid group size is passed
	to a generator's constructor. Valid group sizes
	are >= 0 and <= the number of elements available
	to the generator.
#END
Class CombinatorGroupSizeException Extends Throwable
End Class
#rem monkeydoc
	To be thrown when an invalid number of elements is
	passed to the generator's constructor. For all
	generators, the list of elements must have more 
	than 0 items. For the combinations generator,
	the number of elements must be no larger than thirty.
#END
Class CombinatorElementsSizeException Extends Throwable
End Class
#rem monkeydoc
	To be thrown when a generator is instantiated with 
	no constructor arguments, or with the wrong number
	of constructor arguments.
#END
Class CombinatorConstructorArgumentsException Extends Throwable
End Class
#rem monkeydoc
	To be thrown when one or more of the arguments 
	passed to the generator's constructor is invalid.
#END
Class CombinatorInvalidArgumentException Extends Throwable
End Class