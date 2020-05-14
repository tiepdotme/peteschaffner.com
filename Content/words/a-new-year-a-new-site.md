---
date: 2020-02-23 01:13
---

# A New Year, a New Site

Ok, the site isn't new as in design or content, but the underlying tech is. I guess it is also a little late to be writing a new-year post. Oh well…

+++

## Hosting

I made a resolution this year to support more independent businesses. This site was originally hosted by GitHub Pages, but I decided I didn’t want all my eggs in one basket (being my remote was enough—no need for them to handle building and hosting as well). So I chose [Linode](https://www.linode.com/company/about/). It is an independently held company, has been around for a long time, and has great customer support. Easy choice.

## Site generators

I was using Jekyll because of its deep integration with GitHub Pages, as I liked knowing my site was being automatically built each time I pushed. I wasn’t in love though: I don’t know Ruby, nor do I want to learn it.

I make iOS/macOS apps, so I landed on a relatively new project called [Publish](https://github.com/JohnSundell/Publish). It is written in Swift and works with SPM, so hacking on it in Xcode is a joy. I also am wanting to improve my Swift, so it made perfect sense. Granted at first I thought some of its selling points, like type safety, were kinda overkill for making a website, but in the end I’ve come to really appreciate them.

Publish makes it really easy to get up-and-running, as it supports all the things you typically need out of the box: pages, sections, posts, templates. Nonetheless, I hit a snag when trying to support title-less blog posts[^1]. In order to get that working, I had to use a [healthy](https://github.com/peteschaffner/peteschaffner.com/blob/master/Sources/PeteSchaffner/Theme/Layout.swift#L28) [dose](https://github.com/peteschaffner/peteschaffner.com/blob/master/Sources/PeteSchaffner/Theme/Theme.swift#L27) of [conditionals](https://github.com/peteschaffner/peteschaffner.com/blob/master/Sources/PeteSchaffner/Theme/Theme.swift#L67) in my templates.

[^1]: [Title-less posts](https://manton.micro.blog/2014/09/15/defining-a-microblog.html) have really helped keep me blogging more often, as I don’t have to stew over a title/theme/etc. They also work great with Micro.blog, which in turn helps me easily cross-post to Twitter.

Next, I wanted to keep my draft posts from being published until I was ready—I did like this feature of Jekyll. Getting that required a little more work, though. I needed to fork Publish and add a publishing step that could handle *removing* items. The actual feature was pretty easy to implement, but now I’m just hoping my changes get merged.

## Servers

In the spirit of supporting indie’s, I landed on using [Site.js](https://sitejs.org). It is made by a [little non-for-profit](https://small-tech.org) with good values, and it handles:

- live-reloading browsers
- auto-TLS
- deployment

It saves me a ton of hassle, so I decided to use it locally and on my Linode. It auto-restarts and keeps itself up-to-date, so I feel secure and confident in leaving it alone. Plus, it’s always nice when you can use the same setup locally and remotely.

Whenever I feel like getting an extra pair of eyes before publishing, I use [Emporter](https://emporter.app). It makes my local server visible to the World Wide Web, and is wicked fast at doing it. It’s simple, reliable, and made by my good friend [Mikey](https://youngdynasty.net). What could be better?

## Final touches

When I want to work on the core (templates, publishing steps, etc.), I fire up Xcode. For writing Swift, it’s hard to beat. When it comes time to write prose, I turn to [iA Writer](https://ia.net/writer). It has been a loyal companion over the years.

As I write, [entr](https://github.com/eradman/entr) watches for changes and rebuilds everything. Site.js then refreshes my browser. I also use Site.js to publish everything. Take a look at [the Makefile](https://github.com/peteschaffner/peteschaffner.com/blob/master/Makefile) if you are interested in the details.

And that’s it.
