## SpaceAce Combinatorics for Monkey-X

This module provides functionality for generating combinations and 
permutations of element sets.

### Features
* Generator-style
  * Combinations and permutations are created _on demand_, rather than 
all at once. This makes for a very low memory footprint, even when 
generating enormous numbers of permutations, and makes it very fast to 
access a small number of combinations or permutations from a large 
space.
* Generic
  * All classes in this Combinatorics module are generic. You can simply 
instantiate the classes using the desired type, meaning you are not 
limited to strings, or even to scalar values.
* On-demand transformations
  * You can supply code that will run as each element is selected, 
acting as a sort of just-in-time transformation. This means you don't 
have to generate the entire series, or generate values one at a time, 
and manipulate them after the fact.
* Modular
  * Each class encapsulates a single functionality. This makes it easy 
to combine, say, combinations and permutations. This also makes the code 
easier to maintain and extend. The Permuter class only permutes, and the 
Combinator class only combines, so there is little waste in the code.
* Interface driven
  * All of the SpaceAce Combinatorics classes implements the 
ICombinatoricsGenerator interface, making them easy to swap in and out 
of code, and making it easy to extend the functionality with your own 
classes.
* Reasonably well-documented
  * There are enough comments in the code and examples in 
combinatoricsTestSuite.monkey to keep the barriers to use low.

### Caveats
* The Combinator class is limited to sets of thirty elements or less, 
due to the fact that I am using bit-fiddling to generate the 
combinations. I will add an unrestricted combinator class when time 
permits.
* This module currently supports only combinations, permutations, and 
combinatorial math. In the future, it will also support power sets, and 
possibly cartesian products, and anything else that tickles my fancy.

### Contributing
I welcome suggestions, and pull requests. If you want to add 
functionality to this module, feel free to submit your code. However, 
any code submitted must adhere to the ICombinatoricsGenerator interface. 
I am open to modifying the interface as necessary to make this module as 
useful as possible, but I am not willing to break the convention of 
using generator classes as opposed to pre-calculating all possibilities.

### Classes
**Combinatorics**

The Combinatorics class consists of a number of static functions that 
provide basic combinatorial math functionality.

```
Print Combinatorics.MassPermutationsCount(12)

1302061344
```


<br><br>
**Combinator**

*spaceace.combinatorics.cCombinator*

The Combinator class generates unique combinations of elements, in the 
style of "x Choose y." Note that, due to the bit-fiddling nature of the 
series generator, Combinator can only work with sets of elements 
numbering thirty or less.

```
Combinator([a, b, c, d, e, f, g, h], 6)

[c, d, e, f, g, h], [b, d, e, f, g, h], [a, d, e, f, g, h], [b, c, e, f, g, h]
[a, c, e, f, g, h], [a, b, e, f, g, h], [b, c, d, f, g, h], [a, c, d, f, g, h]
[a, b, d, f, g, h], [a, b, c, f, g, h], [b, c, d, e, g, h], [a, c, d, e, g, h]
[a, b, d, e, g, h], [a, b, c, e, g, h], [a, b, c, d, g, h], [b, c, d, e, f, h]
[a, c, d, e, f, h], [a, b, d, e, f, h], [a, b, c, e, f, h], [a, b, c, d, f, h]
[a, b, c, d, e, h], [b, c, d, e, f, g], [a, c, d, e, f, g], [a, b, d, e, f, g]
[a, b, c, e, f, g], [a, b, c, d, f, g], [a, b, c, d, e, g], [a, b, c, d, e, f]
```


<br><br>
**Permuter** (*spaceace.combinatorics.cPermuter*)

The Permuter class generates ordered (['a', 'b'] and ['b', 'a'] count as 
two different things) sets in the style of "x Permute y."

```
Permuter([a, b, c, d])

[a, b, c, d], [b, a, c, d], [a, c, b, d], [c, a, b, d], [b, c, a, d], [c, b, a, d]
[a, b, d, c], [b, a, d, c], [a, d, b, c], [d, a, b, c], [b, d, a, c], [d, b, a, c]
[a, c, d, b], [c, a, d, b], [a, d, c, b], [d, a, c, b], [c, d, a, b], [d, c, a, b]
[b, c, d, a], [c, b, d, a], [b, d, c, a], [d, b, c, a], [c, d, b, a], [d, c, b, a]
```


<br><br>
**CombinatorPermuter** (*spaceace.combinatorics.cCombinatorPermuter*)

The CombinatorPermuter class generates all combinations of a given size 
from the elements provided, then generates all permutations of thos 
combinations.

```
CombinatorPermuter([a, b, c, d, e, f], 2)

[e, f], [f, e], [d, f], [f, d], [c, f], [f, c]
[b, f], [f, b], [a, f], [f, a], [d, e], [e, d]
[c, e], [e, c], [b, e], [e, b], [a, e], [e, a]
[c, d], [d, c], [b, d], [d, b], [a, d], [d, a]
[b, c], [c, b], [a, c], [c, a], [a, b], [b, a]
```


<br><br>
**MassPermuter** (*spaceace.combinatorics.cMassPermuter*)

MassPermuter generates all permutations of all groups sizes (in the 
range of 1 ... elements.length) of all combinations of its elements.

```
MassPermuter([a, b, c, d])

[d], [c], [b], [a], 
[c, d], [d, c], [b, d], [d, b], 
[a, d], [d, a], [b, c], [c, b],
[a, c], [c, a], [a, b], [b, a], 
[b, c, d], [c, b, d], [b, d, c], [d, b, c], [c, d, b], [d, c, b], 
[a, c, d], [c, a, d], [a, d, c], [d, a, c], [c, d, a], [d, c, a], 
[a, b, d], [b, a, d], [a, d, b], [d, a, b], [b, d, a], [d, b, a], 
[a, b, c], [b, a, c], [a, c, b], [c, a, b], [b, c, a], [c, b, a], 
[a, b, c, d], [b, a, c, d], [a, c, b, d], [c, a, b, d], 
[b, c, a, d], [c, b, a, d], [a, b, d, c], [b, a, d, c],
[a, d, b, c], [d, a, b, c], [b, d, a, c], [d, b, a, c], 
[a, c, d, b], [c, a, d, b], [a, d, c, b], [d, a, c, b], 
[c, d, a, b], [d, c, a, b], [b, c, d, a], [c, b, d, a],
[b, d, c, a], [d, b, c, a], [c, d, b, a], [d, c, b, a]
```

<br><br>
### Installation
Clone or download this repository, then copy modules/spaceace to your 
Monkey-X module directory.

### Usage
Simply import the desired generator(s)
```
Import spaceace.combinatorics.cCombinator
Import spaceace.combinatorics.cPermuter
Import spaceace.combinatorics.cCombinatorPermuter
Import spaceace.combinatorics.cMassPermuter
```

See combinatoricsTestSuite.monkey, as well as the examples above, for 
more help with usage.



