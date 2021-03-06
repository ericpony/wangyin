---
layout: default
title: 漫谈 Linux，Windows 和 Mac
---


好了，现在来一点技术性的。这段时间受到很多人的来信（大部分是菜鸟）。他们看了我很早以前写的推崇 Linux 的文章，想知道如何“抛弃 Windows，学习 Linux”。天知道他们在哪里找到那么老的文章，真是好事不出门。我觉得我有责任消除我以前的文章对人的误导，洗清我这个“Linux 狂热分子”的恶名。我觉得我已经写过一些澄清的文章了，可是怎么还是有人来信问 Linux 的问题。也许因为感觉到“舆论压力”，我把文章都删了 。

简言之，我想对那些觉得 Linux 永远也学不会的“菜鸟”们说：

1. Linux 和 Unix 里面包含了一些非常糟糕的设计。学不会有些东西不是你的错，是 Linux 的错，是“Unix 思想” 的错。不要浪费时间去学习它们的太多东西。那些貌似难的，复杂的东西，特别要小心分析。

2. Windows 避免了 Unix，Linux 和 Mac OS X 的很多问题。微软是值得尊敬的公司，是真正在乎程序开发工具的公司。我收回曾经对微软的鄙视态度。请菜鸟们吸收 Windows 设计里面好的东西。

3. 学习操作系统最好的办法是学会（真正的）程序设计，而不是去“学习”各种稀奇古怪的工具。所有操作系统，数据库，Internet，以至于 WEB 的设计思想（和缺陷），几乎都能用程序语言的设计思想简单的解释。

先说说我现在对 Linux 和相关工具（比如 TeX）的看法吧。我每天上班都用 Linux，可是回家才不想用它呢。上班的时候，我只能说，我基本上只是“忍受”着它。Unix 有许许多多的设计错误，却被当成了圣经，传给了一代又一代的程序员。Unix 的 shell，命令，配置方式，图形界面，都是非常糟糕的。每一个新版本的 Ubuntu 都会在图形界面的设计上出现新的错误，让你感觉历史怎么会倒退。但是这只是表面现象。Linux 的图形界面（X window）几乎是不可治愈的恶疾。我不想在这里细说 Unix 的缺点，在它出现的早期，已经有人写了一本书（名叫 [Unix Hater's Handbook](http://web.mit.edu/~simsong/www/ugh.pdf)) 来发泄对 Unix 的厌恶。（声明一下，我不厌恶 Unix，我只是不再推崇它。我的视野已经高于它，以至于我可以理性的分析它。）

这本书里汇集了 Unix 出现的年代，很多人对它的咒骂。我曾经以为这是一些菜鸟，他们肯定是不能理解 Unix 的高明设计才在那里骂街。现在理解了程序语言的设计原理之后，我才发现，他们说的那些话里面居然大部分是实话！其实他们里面很多人在当年就是世界顶尖的编程高手，功底不亚于 Unix 的创造者。在当年他们就已经使用过设计更加合理的系统，比如 Multics，Lisp Machine 等。可惜的是，Multics 操作系统书籍里面往往只是被用来衬托 Unix 的“简单”和伟大。Unix 的书籍喜欢在第一章讲述这样的历史：“Multics 由于设计过于复杂，试图包罗万象，而且价格昂贵，最后失败了。”  可是 Multics 失败了吗？不。Multics，Oberon，IBM System/38，Lisp Machine，…… 在几十年前就拥有了 Linux 现在都还没有的好东西。Unix 里面的东西，什么虚拟内存，文件系统，…… 基本上都是从 Multics 学来的（有很多没有学得像）。Multics 的机器，一直到 2000 年都还在运行。Unix 不但“窜改”了历史教科书，而且永远不吸取教训，到现在还没有实现那些早期系统早就有的好东西。最后 Unix 依靠自己的“宗教”和“哲学”，“战胜”了别的系统在设计上的先进，统治了程序员的世界。胜者为王，可是 Unix 其实是一个暴君，它不允许你批评它的错误。它利用其它程序员的舆论压力，让每一个系统设计上的错误，都被说成是用户自己的失误。其它系统里面某些优秀的系统设计，也许就要被历史掩埋……

我曾经强烈的推崇 FVWM，TeX 等工具，可是现在擦亮眼睛看来，它们给用户的界面，其实是非常糟糕的设计。他们把程序设计的许许多多的细节，无情的暴露给用户。让用户感觉有那么多东西要记，仿佛永远也没法完全操纵它。实话说吧，当年我把 TeXbook 看了两遍，做完了所有的习题（包括最难的“double bend”习题）。几个月之后，几乎全部忘记干净。为什么呢？因为 TeX 的语言是非常糟糕的设计。它的设计者几乎完全不明白程序语言设计的基本原则，不明白什么叫做“抽象”。

一个好的工具，应该只有少数几条需要记忆的规则，就像象棋一样。而这些源于 Unix 的工具却像是“魔鬼棋”或者“三国杀”，有无数的，无聊的，人造的规则。有些人鄙视图形界面，鄙视 IDE，鄙视含有垃圾回收的语言（比如 Java），鄙视一切“容易”的东西。他们却不知道，把自己沉浸在别人设计的繁复的规则中，是始终无法成为大师的。就像一个人，他有能力学会各种“魔鬼棋”的规则，却始终无法达到象棋大师的高度。所以，容易的东西不一定是坏的，而困难的东西也不一定是好的。学习计算机（或者任何其它领域）的东西，应该“只选对的，不选难的”。记忆一堆的命令，乌七八糟的工具用法，最后脑子里什么也不会留下。学习“原理性”的东西，才是永远不会过时的。

我并不是说 Windows 好很多。技术设计上的很多细节，也许它在早期是同样糟糕的。但是它却向着更加结构化，更加简单的方向发展。我认识一个 Adobe 的高级设计师。他告诉我，当年他们把 Photoshop 移植到 Intel 构架的 Mac，花了两年时间。Xcode 比起 Visual Studio 真是差太多了。而 Mac OS X 的很多设计，让他们的移植实在太痛苦。只不过系统换了个处理器，移植个程序居然花了两年时间。不过他很自豪的说，当年很多人等了两年也没有买 Intel 构架的 Mac，就是因为他们在等待 Photoshop 的移植。最后他直言不讳的说，微软才是真正在乎程序员工具的公司。相比之下，Apple 虽然对用户比较友好，但是对程序员的界面要差很多。

一再宣扬别的系统都是向自己学习的 Apple，受到这样的评价，我一点也不惊讶。Mac OS X 毕竟是从 Unix 改造而来的。我在家里有一个 Macbook Air，一个 iPhone 5，和一个退役的，装着 Windows 7 的 T60。我不得不承认，虽然我很喜欢 Macbook 和 iPhone 的硬件，但我想念 Windows 和 Android 在软件上的一些设计。一个公司的傲气，真的可以阻碍它向别人学习，设计出更好的东西。微软也许在当年是傲慢轻狂的公司，但是我觉得它现在已经度过青春期，长大成熟了。

当然我不是在这里打击 Linux 和 Mac 而鼓吹 Windows。这些系统的纷争基本上已经不关我什么事。我只是想告诉新人们，去除头脑里的宗教，偏激，仇恨和鄙视。每一次仇恨一个东西，你就失去了向它学习的机会。
