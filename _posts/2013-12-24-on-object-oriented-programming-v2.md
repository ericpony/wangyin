---
layout: default
title: On object-oriented programming
---


[written at the end of 2013 AD, during the Dark Ages of programming]

![](http://yinwang0.files.wordpress.com/2013/12/dark_age_battle.jpg?w=300)

The programmer’s world is full of fads and superstitions. Every now and then there will be somebody who come up and announce: “I can save the world!” No matter whether the ideas are good or not, there will always be followers, and the ideas soon become their religion. They then develop their community or camp, try to let those ideas dominate the world, and try to make the ideas live forever.

Object-oriented programming (OOP) is such a religion which claimed to be able to save the world and later developed into a dominant position. As a hindsight after so many years since it was introduced, not only didn’t OOP save us, it brought us more confusion and harm than benefits. In this article, I hope to provide my viewpoint into this matter.

Like every article on my blog, the opinions are completely personal and not representing my employers or professors.

### Is everything an object?

“Everything is an object” is the core dogma of OOP and deemed as the highest standards of OO language design. Now let’s take a careful look to see if it is true, or if it is a good idea to make things that way.

Many people take “everything is an object” for granted because when this sentence is taken literally, it matches their everyday experience. Since the word “object” in English basically means “a thing”, how can “everything is an object” be not true? But be careful, the definition of an “object” in OOP has a specific meaning which is very different from what it means in English.

OOP’s definition of an [object](http://en.wikipedia.org/wiki/Object-oriented_programming) is “a combination of [data fields](http://en.wikipedia.org/wiki/Field_%28computer_science%29) (attributes that describe the object) and associated procedures known as [methods](http://en.wikipedia.org/wiki/Method_%28computer_programming%29)“. Can you really fit everything into this model?

First let’s look at the real world and see if this definition can capture everything. Cars, trees, animals may sometimes be thought of as objects, but what about changes of the objects’ position, its velocity and duration? What methods do they have? Well, you may define classes called Velocity or Time, with methods such as addition, but do velocity and time really contain the things that you call “methods”? They don’t. They are just your imagination. You can add the velocities or time, but how can velocities or time contain the addition procedure? This is like saying that the bullets contain the gun.

So the most you can say is that “everything is an object” is a good way of thinking, but that is not true either. The definition of an object implies that a method can only belong to one object, but most of the time it doesn’t make sense thinking of it as belonging to any object. Say we have the expression 1+2, does the operator ‘+’ belong to 1, or does it belong to 2? You have to make some arbitrary choice. Since you can make a choice, this means that the ‘+’ operator doesn’t really belong to either of them. The operation is inherently outside of the objects.

So thinking of some things as objects may be helpful, but thinking of everything as an object is neither true nor useful. Unfortunately “everything is an object” has been taken as a dogma and the highest standard of OO language design. Some OO languages claim that everything is an object in them. Whenever you notice that something is not an object, somebody will try to make it one. You may succeed in that, but things get very complicated that way, because that’s not how things work.

The idealism of “everything is an object” is similar to “everything is a function” in the functional programming (FP) world and “everything is a set” in the math world. Before computer science was conceived there was a thing called the lambda calculus. Some people encoded everything including numbers and their operations, various data structures and control structures, … all in lambdas. One of the encodings of numbers is called the Church numeral. Every PL researcher has played with them during their training. But unlike “everything is an object”, “everything is a function” has never become a dogma or marketing phrase. Those formulations sometimes provide mental exercises and inspirations to PL researchers but nobody really use them for actual computation, because they are inefficient and they are not really how things work. They are just approximations (models) to some essence of computation that we can’t see. If you really use them for practical projects, things become complicated.

Mathematicians have a similar thing: set theory. Some geniuses encoded everything — numbers, operations on numbers, mathematical structures, … all in sets. Everything is just sets containing sets containing sets. What’s the problem? But when they really tried to do their proofs using those sets, the proofs fell under their own weights. It’s just too complicated. Even with the complexity, set theory is not expressive enough to capture whatever the mathematicians have to say. Many people tried to fix it, but they all failed.

So “everything is an object” is in some sense on the same track of “everything is a function” and “everything is a set”. Good thought exercise, but doesn’t really work well in practice. I don’t think that there is some “one true language”, but this model of OOP is too far from correct or practical. It is like the flat earth theory. When you get the fundamental thing wrong and don’t throw it away, you have to patch it endlessly with even more complicated theories. And this is what happened to OOP.

![](http://yinwang0.files.wordpress.com/2013/12/flat-earth.png?w=300)

### Are functions objects?

The original motivation of putting functions inside objects was to support GUI applications. You click on a button and some function (a callback) will be invoked. For the convenience of referring to the button, the callback takes the triggered object as its first argument. Since the callback does nothing more than this, it seems to be convenient to just store it inside the button. And thus we had an “object” which combines the attributes of the button and a method (the callback). Indeed it is convenient and a good idea. But this limited usage case can’t really justify a universal notion of “everything is an object”.

If you really understand what is abstraction, you may have noticed that even the above story contains a subtle mistake: the callback in the button is not really a method. The true purpose of a method is to provide abstraction to the attributes, but the callback’s purpose is not to provide abstraction. It is just a usual function triggered by the button, which happens to take the button as its first argument.

Very few functions should be considered methods of an object. If you look carefully, most of the time the objects just serve as a namespace (or module) in which you can store attributes and functions, but those functions don’t logically belong to the objects. They just take the objects as inputs and produce some output. Only the functions that are most intimately connected to the attributes and provide an abstraction layer to them should be considered methods. Most of those are called “getters”, “setters” or “iterators”.

In some languages such as Scala or Python, functions are also treated as objects. But actually they just wrapped the functions into an object, give them some name such as `apply` or `__call__`, so that when the objects are “invoked” you know which functions to call. But putting a function into an object doesn’t really mean that functions are also objects, just like inviting friends to your house doesn’t make them your family.

Functions are fundamental constructs. They don’t belong to objects. They describe a change, transition or transformation of objects. They are not objects and can’t be simulated by objects. They are like a base case of an inductive definition. They are where the illusion of “everything is an object” ends.

### The cost of excessive abstraction

The major appeal of OOP is abstraction, but most of those facilities are already provided by traditional procedural languages and functional languages. Some of them do it even better than OO languages. OO claims its originality by emphasizing abstraction much more strongly than other languages. The result is that OO programmers usually overdo it.

For the purpose of “code reusing”, OO encourages a level of abstraction which makes programs hard to understand and hard to analyze. I often see Java programs with multiple levels of inheritance, overloading and design patterns, but actually doing very little. And because there is so much code that doesn’t do useful things, it is really hard to find out which part of the code is doing the thing you want. It is like going through a maze.

Whenever you complain about Java or C++, OO proponents will tell you that they are not authentic OO languages. They would ask you to look at Smalltalk. If Smalltalk’s ways are that good, why almost nobody is using Smalltalk now? Because there are real problems in its approach. I think Smalltalk is the origin of over-complications you find in other OO languages.

The “authentic” OO style of Smalltalk promotes the notion of “extremely late binding”, which basically means that the meaning of the program constructs is determined as late as possible. Late binding means that you have a chance to swap out the underlying implementation without forcing the upper levels to change, but it also means that you are no longer sure what a piece of code means. When I look at expressions such as ’1+2′ and ‘if (t) then … else …’ in Java or C++, I at least know for sure that they mean an integer addition and an usual conditional. But I’m no longer sure about this in an “extremely late binding language”, because the meaning of ‘+’ and ‘if” can be redefined. It is bad idea of giving the programmers the power of defining control structures, because soon your language will be abundant of quirky control structures designed by programmers who try to be clever. It will no longer be the language that you used to know.

An example for this feature is Smalltalk’s conditional structure, which looks like this:

    result := a > b     
        ifTrue:[ 'greater' ]
        ifFalse:[ 'less or equal' ]

You send a message ifTrue: to a Boolean object, passing as an argument a block of code to be executed if and only if the Boolean receiver is true.

First of all, if you really have a well designed language, you shouldn’t be wanting to define your own control structures. As a seasoned Lisp/Scheme programmer, I have seen many custom-designed control structures as macros over the years, but almost none of them turned out to be good ideas. The reason is, probably, we have invented all the good control structures in all programming languages. Second, if you are really genius enough to have invented another good control structure, this feature Smalltalk probably doesn’t provide you the power for defining it. The power of functions as an abstraction tool is limited. It is strictly less powerful than Lisp/Scheme’s macros. Third, this feature of Smalltalk is not really a novel approach and it has a big problem. A similar but more beautiful conditional construct had been defined in lambda calculus since before computer science was born:

    TRUE = λx.λy.x
    FALSE = λx.λy.y
    IF = λb.λt.λf.b t f

This is very beautiful and can be done in any functional language, but why none of the functional languages implement conditionals this way? Because when you see an expression IF b t f, you will have no idea whether it is a conditional or not, because IF can be redefined in the program. Also because IF is just a function, it may also accept unexpected values other than TRUE or FALSE. This may happen to make the conditional construct work but cause trouble later on. This is called “unintentional semantics”. This kind of bug can be very hard to track down.

This approach also makes compiler and static analysis hard. When the compiler sees IF b t f, it no longer knows that it is a conditional and thus optimize it that way. It has to treat it as a usual function call. Similarly when the type checker sees it, it doesn’t know what type to expect for b, because it may not be a conditional at all.

So abstraction is a powerful weapon when used moderately, but when you do it in excess, it backfires. Not only does it make it hard for humans to understand the code, it makes automated analysis tools and compiler optimization difficult or impossible to make.

### Design patterns eat brains

Although OO languages are touted for their ways of abstraction, they are actually not strong in terms of abstraction ability and expressiveness. There are certain things that are very easy to do in functional languages but was made unnecessarily hard in OO languages. This is why design patterns appeared. Design patterns’ origin was mostly due to the dogma of “everything is an object”, the lack of high-order functions (or the correct implementation of them) and OO’s tendency of mystifying things.

When I first heard about design patterns I was already a PhD student at Cornell doing some PL research. I mostly used Standard ML and Haskell. I was curious about the [Design Patterns](http://en.wikipedia.org/wiki/Design_Patterns) (nicknamed “GoF”) book’s fame so I borrowed one from the library. Within a few hours I found a mapping from all the weird names it introduced to the programming techniques I had been using all the time. Some of them are so fundamental and exist in every high-level language, so they don’t really need names. Most of the advanced ones (such as visitor) are transcriptions of functional programming concepts into a convoluted form in order to get around OO language’s limitations. Later on I found that Peter Norvig already gave a talk on design patterns as early as 1998, pointing out that almost all of the design patterns will be “transparent” once you have first-class functions. This confirmed my observations.

I have to admit that some of the design patterns are cleverly designed and contain some ingenuity. You really need to get to the essence of the OO languages’ internal designs and also understand lots of functional programming techniques in order to create them. But intelligence =/= wisdom. Even if you can achieve what functional languages can do, it usually becomes a lot more complicated. Choosing the hard ways can’t really prove your genius. When you have first-class functions, things become so much easier and you won’t even notice the design patterns’ existence. Like Peter Norvig said, the design patterns will become transparent. So what a good language designer should do is to add first-class functions into the language and not to use design patterns as workarounds.

Every time I remove a design pattern (some other people wrote), the code becomes simpler and more manageable. I just removed the last visitor pattern from my Java code a few days ago and I felt so relieved. They gave me nothing but extra work when they existed. They hindered my progress. By deeply understanding how OO languages are implemented, you can write more advanced things than those provided by visitor patterns, but without actually using them. I owe these insights into design patterns to some functional programming people. If you really want to understand the essence of OO design patterns and how NOT to use them, take a look at [this little book](http://www.amazon.com/Little-Java-Few-Patterns/dp/0262561158).

Unfortunately design patterns got really popular in companies, to the degree of unbearable. I saw the GoF Design Pattern book on almost every bookshelf when I interned at Google. Even if you don’t write them yourself, there was almost no way you could avoid other people slipping design patterns into your code. Design patterns’ marketing strategy as I perceived was much like weight loss products: “It can burn your fat without you doing any work!” They appeal to some new programmers’ hope that they can write programs without understanding the fundamental concepts of computer science. Just by applying several patterns and patching things together, they hope to have a good program. This is too good to be true. You end up doing more work than you hoped to avoid. Design patterns eat programmers’ brains. They no longer see things or write program in a straightforward way.

### What is OO any way?

To this point we haven’t yet talked about what makes a language an “OO language” and what makes it not. Is it an OO language just because I can put both data fields and functions into a record? Or is it an OO language only if it also provides extremely late binding? How about inheritance, overloading, etc etc? Must I have all of them? Any of them?

It turns out there is no good answer to this question. There really is no such thing as an “object-oriented language”. Objects can be part of a language, but it is just a small part of it. The so-called OO languages are rooted in traditional procedural programming, some with things from functional languages. You can’t really say that a language is object-oriented just because it provides objects as a feature.

Historically the term OO’s existence was mainly due to marketing reasons. It could give you some advantage of attracting certain people if you claim to be an OO language. But this advantage is diminishing because more and more people have realized the problems of OO’s methodology.

### Harm in education and industry

Although OO has lots of problems, it is very successful in marketing and has risen to a dominant position over the years. Under social and market pressure, many colleges started to use OO languages such as Java as their introductory language, replacing the traditional procedural languages such as Pascal and functional languages such as Scheme. This has in a large degree caused the students’ failure to learn the most essential concepts of programming. The only thing that OO emphasizes is code reusing, but how can you teach it to the students who can’t even write usable code, not to mention that code reusing is not really as important as some people believe.

At both Cornell and Indiana, I have been a TA for introductory programming courses in Java. I did it for multiple semesters. I still remember how confused the students were. Most of them had trouble understanding things such as the meaning of “this”, why everything needs to be put inside classes, why make every field private and use getters, the difference between a method and a static method, etc etc.

There is a good reason that they don’t understand — because OO is not how things work. Most of the time I feel that I was teaching design flaws and dogmas to them. Many of them learned very little in the end. Worse, some of those students really believed in OO. They ended up being proud of writing over-engineered and convoluted code and no longer see things or write programs in straightforward ways. This is sad. I feel that we are no longer educating students as creative and critical thinkers, but mindless assembly line workers.

![](http://yinwang0.files.wordpress.com/2013/12/modern-times.jpg?w=300&h=213)

In industry, OO hasn’t really proved its effectiveness with evidence. Good systems may be built in a “OO language”, but the code is often written by people who understand the problems of OO and don’t embrace “everything is an object” or “design patterns”. Good programmers usually use workarounds in OO languages and are essentially writing in a traditional procedural style combined with bits from functional programming. So some OO languages and their tools may be pretty widely used, but the OO style doesn’t really have much influence on the advancements of programming as a field.

### Final word

So what does this post has to say? A jihad against OO languages? Advocate functional programming? Neither. As I said, there is no such thing as an “OO language”. Every so-called OO language also contains good elements that you may find in procedural languages or sometimes functional languages, so they are not completely horrible. I don’t believe that there is war between OOP and FP, since they are both elements that can coexist in any language.

But honestly, the OO techniques contain way more confusion than real value, so this article is here to encourage critical thinking about the OO techniques and improve awareness of the adverse effects they have brought us. Accepting everything from OO methodology will probably put you into the problems that I have described. By being critical about OO methodologies, with certain knowledge of procedural, functional programming and some workarounds, you can also produce excellent code in an OO language. The point is really a warning not to buy too much into OO.

I also don’t push you toward functional programming. Although I have been educated by FP people, my first language was Pascal. I still see valuable things in Pascal although I no longer use it. Now I use both OO languages and functional languages, and sometimes logic languages. I eschew the problematic features from both OOP and FP. I use OO languages mostly as a procedural language, with some bits from functional programming and logic programming. I see lots of value in procedural programming that doesn’t necessarily exist in functional languages, and vice versa. I’m also designing a language myself, hopefully with the all the good bits I see in programming languages and with all the weaknesses removed.