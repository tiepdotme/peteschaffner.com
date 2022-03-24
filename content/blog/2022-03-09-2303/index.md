---
date: 2022-03-09T23:03:36+01:00
---

I prefer to use (and make) native software, so it was encouraging to read this [Twitter thread](https://twitter.com/siegel/status/1427067920102961154) by Rich Siegel, the maker of [BBEdit](https://www.barebones.com/products/bbedit/index.html).

I’m going to record it here both so it is easier to read and for archival purposes.

---

[Tweet 1](https://twitter.com/siegel/status/1427067920102961154):

> All right, let's do this.
>
> It is time to speak of many things. Before I start I want to make a few things crystal clear:
>
> 1. Except for my own experiences and matters of objective fact, everything I have to say about matters Electron-adjacent is MY OPINION. Don't @ me.

<!--more-->

[Tweet 2](https://twitter.com/siegel/status/1427068635248578561):

> 2. Many of my views on these matters come from having learned how to write Mac software at a time when the typical target machine had 512KiB (that's 524,288 BYTES) of RAM, no swap, 20KiB/s disk I/O, and an 8MHz CPU with eight data registers and eight address registers.

[Tweet 3](https://twitter.com/siegel/status/1427069226666401792):

> I started writing software for Macs in 1985. During the formative years of my career I had the extreme good fortune to be mentored by people whose work shaped Mac development for the next 20 years. They constantly made me think about the cost of a function call, and…

[Tweet 4](https://twitter.com/siegel/status/1427069913781448704):

> …the phrase "space/time tradeoff" came up a lot. These people knew what they were talking about: they invented LightspeedC and Lightspeed Pascal, which between them shaped the Mac development *and* product landscape. Some of my mentors and colleagues went to work for…

[Tweet 5](https://twitter.com/siegel/status/1427070778328092672):

> …Metrowerks, where they continued to do groundbreaking work to advance the state of Mac development. One of my mentors in particular wrote the optimizing code generators for both Lightspeed Pascal *and* CodeWarrior. Both 68K and PowerPC. His obsession was to generate…

[Tweet 6](https://twitter.com/siegel/status/1427071207057330181):

> …the fastest, most compact possible code when optimizations were enabled. Because that mattered, especially on Mac laptops where cycles were even more precious and energy reserves could be finite. So, I "grew up" thinking that it's the programmer's responsibility to ensure…

[Tweet 7](https://twitter.com/siegel/status/1427071720960282625):

> …that their code was as *efficient* as possible. Whether that meant speed, or compactness, or both. Because it mattered. It still does, even though we're not shipping code on floppies or CDs, and even though we're not (all) using 56Kbaud modems to download a .hqx from a BBS.

[Tweet 8](https://twitter.com/siegel/status/1427072914709520388):

> So, when I download an app that I and a lot of my peers use in the ordinary course of getting work done, and I get info on it, and I see that it's 180MB (Discord), or 400MB (Dropbox), or 200MB (Slack), or 280MB (Skype), and I know it's a front-end to a web service, well…

[Tweet 9](https://twitter.com/siegel/status/1427073443401551879):

> …honestly, I cringe, every time. Because an electron "Hello World" is… 185.1MB according to the Finder. (That's probably not optimized.)
>
> So for every Electron app I download, there's a pretty significant chunk of disk space, gone, poof. Because there's no sharing…

[Tweet 10](https://twitter.com/siegel/status/1427073909011136515):

> …of common framework code and resources. And that brings us to the "MacApp problem."
>
> MacApp was the first application framework for the Mac. (We called them "class libraries" back then.) It was written in Object Pascal. It was clever and innovative. It implemented…

[Tweet 11](https://twitter.com/siegel/status/1427074524596645892):

> …a whole raft of desirable Mac application behaviors that developers used to have to roll from scratch. It was compiled using MPW, which (before Lightspeed Pascal 2.0) had the best 68K Pascal compiler out there. It was HUGE. And MacApp was not part of the OS, so every…

[Tweet 12](https://twitter.com/siegel/status/1427075610145402885):

> …application that used it had to carry the ENTIRE compiled code and resources of the ENTIRE class library. So applications that used MacApp were huge. (By the standards of the day, at least. We're talking a few megabytes, total.) And that was the problem with MacApp…

[Tweet 13](https://twitter.com/siegel/status/1427076215257579523):

> …was that the baseline was huge, and none of it was shared. So for every product that used the framework, you ended up paying a substantial price in RAM and disk footprint. And so it is with Electron. Every time you download & run an Electron app, you're paying the price…

[Tweet 14](https://twitter.com/siegel/status/1427076731471605760):

> …all over again. PLUS when you run, you're paying the price to load WebKit2, which is a complete, fully functional, WEB BROWSER framework. But hey, at least WebKit2 is shared code.

[Tweet 15](https://twitter.com/siegel/status/1427077183307137024):

> So as someone who grew up caring about efficiency, as it extends to keeping things as small, fast, lean, and resource-aware as possible, this aspect of Electron *really* bothers me. And that’s *my* thing, but I get a pretty clear sense that it’s not just me. However, I’d…

[Tweet 16](https://twitter.com/siegel/status/1427077693200388097):

> …be lying if I said that I didn’t resent being required to pay this price in order to use everyday productivity tools such as the ones that I named earlier in this thread. Again, though, that’s me and as you can probably gather, on an everyday basis I spend zero time…

[Tweet 17](https://twitter.com/siegel/status/1427078676416536580):

> …thinking about that aspect of it. But I think this aspect of efficiency is *still* important, because (I assert that) if you write code thinking about the constraints of 1980s/90s Mac hardware, your product will ABSOLUTELY SCREAM on today’s Macs.

[Tweet 18](https://twitter.com/siegel/status/1427079440773812225):

> So, there’s that thought (for now). Now, about “cross platform”. (Yes, I have Many Thoughts about that, too.) I am firmly of the opinion that “cross platform” means that users of each (desktop) platform that the product supports can enjoy a platform-optimized experience…

[Tweet 19](https://twitter.com/siegel/status/1427079916818997251):

> …which is tuned in *both* performance/efficiency *and* UI behavior for the desktop platform on which it is running. Mac users get canonical Mac application appearance and behaviors; so too do Windows and Linux users. That includes EVERYTHING that makes the platform…

[Tweet 20](https://twitter.com/siegel/status/1427080499101589506):

> …appealing to its respective audience. To me, a successful cross-platform product consists of three layers:
> 1. The high-level UI/UX: platform-tuned, natively implemented using the platform-provided native framework.
> 2. The “business logic” which is platform-portable by…

[Tweet 21](https://twitter.com/siegel/status/1427081041790054404):

> …design and intent, and which implements the non-user-facing parts of the product’s feature set;
> 3. The bare-metal interface between the business logic and the platform services (file I/O, networking, etc). As with #1 this is platform-tuned and natively implemented using…

[Tweet 22](https://twitter.com/siegel/status/1427081623015669761):

> …code that is optimized to be as fast and as efficient as possible.
>
> Out of necessity, there *has* to be some abstraction to ensure portability, but it’s internal and it’s unique and tuned for the product’s needs. (Oh and: this approach works for multiple single-platform…

[Tweet 23](https://twitter.com/siegel/status/1427081971109441536):

> …products too, especially if they have a lot in common. For example, a text editor and an email client. But I digress.)
>
> However. Notwithstanding a necessary amount of abstraction, NOWHERE in this architecture is there room for a least-common denominator UI/UX. Might…

[Tweet 24](https://twitter.com/siegel/status/1427082264320557058):

> …users on different desktop platforms end up having a different experience? Of course. And if you have to bounce back and forth between them frequently, there’ll be some adjustments but humans are pretty flexible. But the goal (to me) is that each *platform audience* gets…

[Tweet 25](https://twitter.com/siegel/status/1427083027025469441):

> …the experience that they expect ON THAT PLATFORM. *Not* a least common denominator UI. I think each platform’s respective audiences deserve that. Otherwise, what’s the point? (That was a rhetorical question, but actually, now that I mention it…)

[Tweet 26](https://twitter.com/siegel/status/1427083608892837895):

> …so, here’s where things start to get a little controversial. Electron is an *extremely* effective way for developers to rapidly bring up an application. It’s a fully functional application framework. It’s as close an expression of the original ideal of “write once, run…

[Tweet 27](https://twitter.com/siegel/status/1427084091661459460):

> …anywhere” as I can think of. (That term first came out of Sun’s marketing for Java. A lot of us made fun of it back then, mostly because it wasn’t true at the time.) And of course with Electron, you get a common UI/UX for all of your target platforms, deploy everywhere…

[Tweet 28](https://twitter.com/siegel/status/1427084789698420737):

> …make use of existing Web design and development resources, etc, etc. But. All of those upsides come at the cost of everything I’ve just finished laying out. And things start to get really sticky, because if you take a survey of the Electron products that have become…

[Tweet 29](https://twitter.com/siegel/status/1427085708674670592):

> …entrenched in our daily lives, they almost all come from companies that have specific BUSINESS goals for developing them that way. It’s entirely natural to want to manage costs. I am now going to quote things, just to make clear that I’m telling a story:

[Tweet 30](https://twitter.com/siegel/status/1427085861779353605):

> “Platform-tuned products cost more to develop because we need platform-specific UI design and implementation expertise.”

[Tweet 31](https://twitter.com/siegel/status/1427086461036371969):

> “We have to provide a consistent UI/UX on all of the platforms we support.”
>
> “This product has to be cross-platform because we want to maximize the audience because USD$reasons.”
>
> These quoted statements may be factually or arguably true, but I think that the seed of…

[Tweet 32](https://twitter.com/siegel/status/1427087030878621698):

> …least-common-denominator cross-platform apps is planted there. And I think that in companies that are of a certain size, or which are funded a certain way, or for which the founders have certain goals (read: IPO/exit)…

[Tweet 33](https://twitter.com/siegel/status/1427087482114527233):

> …these statements are accepted as axiom, and set the course of development. And Electron, being as it is extremely effective at implementing any or all of those axioms, is the solution that is immediately to hand.
>
> You can probably imagine how I feel about that, too but…

[Tweet 34](https://twitter.com/siegel/status/1427087838177333251):

> …I’ll spell it out: I am not a fan of such thinking. I have ABSOLUTELY no doubt in my mind that the INDIVIDUAL rank and file designers and engineers involved in these products are talented professionals who are doing their level best to make a great product. But I believe…

[Tweet 35](https://twitter.com/siegel/status/1427088498599813127):

> …that INSTITUTIONALLY, the company has determined that its business goals are better served by shipping an Electron app with an LCD UI, even though it’s ultimately (again, my opinion) at the cost of making the product a better citizen of the platform on which it runs.

[Tweet 36](https://twitter.com/siegel/status/1427090281975975939):

> …OK, one more thing and then it’s time for Matlock.
>
> I was a Mac developer when Apple was doomed. I think that Electron apps ensure that macOS will forever remain *primarily* a platform for developing native software for OS devices (and associated work). Why?

[Tweet 37](https://twitter.com/siegel/status/1427090866108305420):

> Because thanks to Electron, the everyday business productivity tools that everyone (including OS developers) use can run on ANY platform. There’s no reason to buy a Mac if you don’t get to use the unique advantages of the platform (because Electron apps don’t expose them).

[Tweet 38](https://twitter.com/siegel/status/1427091453352849408):

> So, companies that use those everyday productivity tools can buy hardware for cost (and big companies do) because it doesn’t matter: they can all run Slack, GitHub Desktop, Skype, Dropbox (and MS Office is deployed natively everywhere, bless you [@Schwieb](https://twitter.com/Schwieb)), VS Code, whatever.

[Tweet 39](https://twitter.com/siegel/status/1427092470026940423):

> So the only reason to buy a Mac would be to do things that you can only do with a Mac: 1. Develop and ship products for OS devices. 2. Run Final Cut Pro. 3. Run Logic Pro. (I know ~nothing about media production. But Apple marketing seems to put a lot of stock in it.)

[Tweet 40](https://twitter.com/siegel/status/1427092976141053954):

> And, yes, I’m sure there’s a great deal more that Macs are uniquely able to do, or that they do better than any other machine. And those are all valid things, but I assert that none of them adds up to the combined audience of the current range of Electron apps, which…

[Tweet 41](https://twitter.com/siegel/status/1427093529734549508):

> …insofar as there is one at all, is the immediate point that I’m trying to make.
>
> So. I realize this latest round of Electron hate started because one developer with a widely known and respected product is taking a lot of heat…

[Tweet 42](https://twitter.com/siegel/status/1427094294054195200):

> …for having released a beta of their next macOS version as an Electron app. But in all candor, all the recent news has done is to give me a reason to think more deeply about the issues that I see in Electron (which are NOT specific to their company)…

[Tweet 43](https://twitter.com/siegel/status/1427094876773040131):

> …and reflect a bit on history.
>
> I’m sure I will think of something I forgot to say, but that’s all I have for now. I appreciate all of you who’ve taken valuable time out of your lives to read this far.