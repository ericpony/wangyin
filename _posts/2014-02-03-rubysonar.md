---
layout: default
title: RubySonar: a static analyzer for Ruby
---



(This is a reposting of a [blog post](https://sourcegraph.com/blog/rubysonar) I wrote on [Sourcegraph](https://sourcegraph.com/)‘s website)

Since the last enhancement to our Python analysis, we have been working on improving the Ruby part of Sourcegraph by building a similar static analysis tool for Ruby. The result is a new open-source project[RubySonar](https://github.com/yinwang0/rubysonar). With its help, now we are happy to see significantly improved results of Ruby repos which in general finds over ten times more symbols, provides more examples and more accurate jump-to-definition. It also provides local variable highlighting which was not available in our previous Ruby results. With the improved speed of analysis, we can now process the full [Ruby standard library](https://sourcegraph.com/github.com/ruby/ruby),&nbsp;[Ruby on Rails](https://sourcegraph.com/github.com/rails/rails), and Ruby apps such as [Homebrew](https://sourcegraph.com/github.com/Homebrew/homebrew).

![](https://s3-us-west-2.amazonaws.com/sourcegraph-assets/rubysonar1.gif)

RubySonar’s analysis is interprocedural and is sensitive to both data-flow and control-flow, which makes it highly accurate. Although we currently don’t show the types, RubSonar internally uses the same type inference technique of PySonar, and thus can resolve some of the difficult cases that can challenge a good Ruby IDE.

Although Ruby and Python seem to be very similar languages, lots of work has been done to adapt PySonar’s code to Ruby. Still more work has to be done before RubySonar can achieve the same coverage of PySonar2, but so far the Ruby results are a lot more usable. We have been carefully keeping things simple and easy to extend, so we are optimistic about further improvements to the Ruby analysis.
 