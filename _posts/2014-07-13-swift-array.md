---
layout: default
title: Design issues in Swift language’s arrays
---



In Xcode 6 beta2, you can write the following piece of Swift code:

    let a = [1, 2]      // a refers to an immutable array
    var b = a           // b refers to the same array, but b is mutable
    b[1] = 3            // change contents of b, a also changed
    a                   // a is now [1,3]
    b                   // b is now [1,3]

(Note: the keywords `let` and `var` are Swift’s way of declaring immutable and mutable variables, respectively.)

The let on Line 1 has caused an immutable array to be created, but then by aliasing this immutable array with a mutable variable b (Line 2), we are now able to change the contents of the supposedly immutable array (Line 3). This is obviously a mistake in the language’s type system.

### A troublesome solution (Xcode 6 beta3)

Apparently the Swift language team noticed this problem, so in the new Xcode 6 beta3, something changed:

    let a = [1, 2]      // a refers to an immutable array
    var b = a           // b refers to a mutable array, a copy of array a
    b[1] = 3            // change contents of b, a does not change
    a                   // a is still [1,2]
    b                   // b is now [1,3]
    
Now aliasing an array will cause the array to be copied. Isn’t that weird? According to unofficial sources, the array may or may not be copied, depending on whether the contents of the array is modified or not. Or we may call it “copy-on-write”?

My guess is, in order to fix the previous erroneous design, they decided to make a copy of the array, so that effectively, the mutability of the original array does not change. This is true because there is no way you can change the original array by using its copies.

I’m not exactly sure whether the change is supposed to be a fix for the array’s typing. It might be for some other purposes. But if its purpose is as I have guessed, this solution is not quite right. The primary problem is that it causes inconsistency in the semantics and doesn’t agree with the programmer’s mental model about arrays and objects. In the programmer’s eyes, arrays are just objects. If var b=a creates a shared (not copying) reference to an object, it should also create a shared reference to an array. But now arrays may be copied. Why should arrays be different? Why should I know whether the array will be copied or not? When and where? The copying happens implicitly, which is likely to be a major source of subtle bugs. Also, if each alias creates a copy, then how do you specify it when you really want to share the same array? You’ll need some other notation for this purpose.

When something feels so unnatural, there must be a better way around.

### The root of the problem

The root of the problem is that the type system treats `b = [3,4]` and `b[1] = 3` the same way while they should have been handled differently. This is very similar to a subtle bug (also regarding array assignment) that I fixed in Coverity’s static analysis software, so I’m quite ready to dig out my understanding here.

At the assignment `b[1] = 3`, the type system accepted it because `b` is a mutable variable, so it thinks that `b[1]` must also be mutable. But this is not the case. b is mutable doesn’t necessarily mean that `b[1]` is also mutable. `b` and `b[1]` are very different things. `b` is a variable, while `b[1]` is a part of the object that b points to. They are different locations, at different levels of indirection. To put into a diagram:

(mutable variable b) —> (immutable array containing 1 and 2)

Observe that `b` is a mutable variable on the stack, referencing an immutable array in the heap. `b[1]` is part of that immutable array, thus it should be immutable. Thus the assignment `b[1] = 3` should have been rejected by the type system while `b = [3, 4]` is totally legitimate.

By carefully modeling the above brain reasoning in the type system, the problem can be fixed without any change to the language’s semantics. If you are interested in how this can be implemented, read on.

(The rest of this section is for type system experts and can be skipped by casual readers.)

The original mistake was probably due to the structure of the “typing environment” that the type system passes around. Conventionally this environment is a map from variable names to types. This works for many other languages because they don’t have mutability constraints. But once you have it, you’ll need to pass around some additional data.

For example, after the line let `a = [1, 2]`, you will need to keep track of the mutability of both the variable a and the array [1,2]. This can’t be readily done with just one typing environment, because the environment is a map from variable names to a single type. Each type can only represent the mutability of one object. But now you have two!

How can you keep track of the mutability of both the variable and its value object? One way to do it is to pass two type environments around, one for variables, one for objects. You could also multiplex the value in one type environment, and just tag the mutability with different sub-keys.

I guess in beta2, Swift’s type inferencer only kept the mutability of the variable (and not the object) in the typing environment, and made copies of the type when the object is aliased. This effectively models a different semantics where the objects are copied while they are aliased. In order to make the type system sound, beta3 changed the semantics of the language to fit the type system. This is strange, because usually it’s the other way around: when the type system is unsound, you change the type system to fit the semantics of the language.

### Additional issues

There is closely related issue I hope to address here, so that we can arrive at a clearer design in the next section. It is about the “quantification range” of let and var. In this line:

    let a = [1, 2]

Does let make the variable a immutable, or does it make the array `[1, 2]` immutable, or both?

In this respect, I think Swift is over-multiplexing the functionality of let and var. Ideally they should only mark one thing as immutable or mutable, but after some simple experiments you will see that let marks both the variable a and the array `[1, 2]` as immutable, thus prohibits both `a = [3, 4]` and `a[1] = 3`. This is vague.

To be more precise, we should separate the mutability denotations for the variable a and the array `[1, 2]`. If we choose that let makes only the variable a immutable, then we need some other marker to make `[1, 2]` immutable—we need a separate constructor (type) for immutable arrays.

How do you pass an immutable array to a function? You can’t just say `f([1, 2])`. You have to come up with something else. So again, distinct constructors (and thus types) for mutable and immutable arrays seem to be necessary, if you hope to reason about the mutability of objects at all. Objective C’s ways are not all bad :-)

### Suggested change

Combining the ideas of the previous two sections, the suggested change is as follows:

1. Use let and var to specify only the mutability of variables, but not their initializers. Thus `let a = [1, 2]` will only make the variable a immutable, but `[1, 2]` remains mutable.
2. Use separate constructors MutableArray and ImmutableArray to create arrays. If you like succinct syntax, you may use something like `[: 1, 2 :]` for an immutable array and `[1, 2]` for a mutable one.

Some examples to illustrate what I mean:

    var a = [: 1, 2 :]  // mutable variable refers to an immutable array
    a[1] = 3            // type error: changing contents of immutable array
    a = [: 3, 4 :]      // okay: a can be changed to point to another array, 
                        // because although the array is immutable,
                        // the variable itself is mutable

    let b = [1, 2]      // immutable variable refers to a mutable array
    b = [3, 4]          // type error: b is immutable and can't change to 
                        // point to another array
    b[1] = 3            // okay: able to change the contents of the array, 
                        // because although the variable is immutable, 
                        // the array is mutable
    
    var c = [: 1, 2 :]  // c points to an immutable array
    var d = c           // d points to the same immutable array
    d[1] = 3            // type error: trying to modify immutable array 
                        // although the variable d is mutable

In this way we clearly guarantee the mutability of arrays, and it is also consistent with the programmer’s mental model when objects are aliased. No unnecessary things to learn and to remember. This is similar to Objective C’s way of handing arrays, but unlike Objective C, mutable/immutable arrays don’t subclass each other, otherwise we get the same aliasing problem as in the first example.

### Additional questions

* Is there really a need to have immutable variables (by using let) at all if we already have separate constructors for immutable objects?
* Is there really a need to distinguish mutable/immutable objects after all? It has very little use in preventing errors, so the only benefit might be in performance. How much performance gains have actually caused by it in Objective C or C++?
Related Post

Since C++ has similar mutability annotations, you may be interested in an older post I wrote about C++’s const annotations: How to reduce the contagious power of ‘const’.

 

