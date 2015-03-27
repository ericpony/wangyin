---
layout: default
title: What makes Python static analysis hard and interesting
---



Python is a dynamic language in the authentic sense. It represents the world-view that types don't really exist in reality, and this is probably right. Type systems are "thinking tools" that only exist in our head. They help us reason about programs, but the world doesn't really work in their ways. Types help prevent basic programming errors, but if not designed properly, a type system can be a big impedance to the programmer's productivity. Years of cutting-edge research still haven't produced a type system that won't get into the programmers' way, but you can still write useful program without a static type system. This is why dynamic languages such Python, Ruby and JavaScript are attractive to people, especially those who want to express themselves more directly and don't like to go out of their way to make type systems happy.

But this directness and ease of use have a cost. Making IDEs and refactoring tools is a hard problem for Python. Type errors are hard to catch. For a simple example, the current state-of-the-art in Python IDEs is like the following.

![](https://s3-us-west-2.amazonaws.com/sourcegraph-assets/pycharm-declaration.png)

I loaded this tiny program into the most recent version of JetBrains PyCharm (3.0.2), a Python IDE, and pressed the "show declaration" key on the field accessor foo, and it gave me three irrelevant choices, without including the right one.

Despite this limitation, PyCharm is still a really nice tool. I like PyCharm and use it myself. But this problem of finding the correct declaration of foo is harder than you might have thought. Without knowing what x is, how would you find the declaration of foo? This requires an "interprocedural analysis" where you track all the places where function f can be called. This could be many levels deep into the call chain. And because you can use functions as values, you sometimes don't even know which function a name represents. You have to keep track of the type information that flows around this intricate data and control flow. Doing interprocedural analysis is hard in general, and it is even harder in a dynamic language with features such as first-class functions.

Finding type errors in Python is also hard. PyCharm would not report any problems for the following piece of code, but when you run it, you get a type error because you are adding the string "hi" and the integer 1. The if statement sets x to different types in different branches (int and str), and this confuses PyCharm's type checker.

![](https://s3-us-west-2.amazonaws.com/sourcegraph-assets/pycharm-branch.png)

This might not be a big problem for an IDE, but as a semantic code search and browsing engine, we at Sourcegraph must do better, because if we can't resolve the names, we will not have any usage information about that piece of code. We want to get as much information about code as possible. For this purpose, we use PySonar, a static analysis tool for Python. PySonar can handle the above cases, and a lot more complicated ones.


![](https://s3-us-west-2.amazonaws.com/sourcegraph-assets/pysonar-declaration.png)

![](https://s3-us-west-2.amazonaws.com/sourcegraph-assets/pysonar-typecheck.png)

PySonar is at its core an "abstract interpreter". It basically works like a Python interpreter, only that it doesn't really execute the program. It implements almost everything in Python: modules, classes, objects, functions (closures), etc. It transfers "abstract values" (types) instead of actual values. It explores all possible execution paths of the program, and it always terminates. This simple technique works surprisingly well.

Working on PySonar is interesting because you think about the world philosophically with a "multiple worlds" model. If you don't know the answer to a decisive question in your life, what can you tell about the future no matter what the answer is? The trick is to use as much information you can get, put it into the possible "branches", and try to deduce conclusions from what you have. This is basically what mathematical proofs are about—I don't know what the natural number N is, but a natural number can only be 1) zero, 2) M+1 where M is some other natural number. So as long as I know that 1) P holds for zero, and 2) P holds for M+1 whenever M is another natural number, then I know that P holds for all natural numbers.

Similarly in the above example, PySonar knows that if we don't know what z is, x could be either an integer or a string. A program is safe only if it is safe in all possible worlds, thus PySonar knows that things could go wrong when we try to execute x+1. This kind of reasoning is done pretty easily by building so-called "models". Models abstractly represent things inside the program's execution. Old models transform into new models when actions happen in the program, and the "world" of models split at branching statements.

![](https://s3-us-west-2.amazonaws.com/sourcegraph-assets/pysonar-multiple-worlds.png)

The new [PySonar2](https://github.com/yinwang0/pysonar2) is a lot better than its predecessor. Its interprocedural analysis finds more declarations and more precisely. It also generates type information which can be helpful for understanding programs. This type information is already available on Sourcegraph for many Python repositories.



The recent additions to PySonar2 are intersection types, a more principled way of handling union types, and lots of improvements to its performance and simplicity. I'm also working on porting the same techniques to Ruby.

