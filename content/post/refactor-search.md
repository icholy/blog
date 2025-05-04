+++
Description = ""
Tags = ["Development"]
Categories = ["Development"]
date = "2025-05-02T09:25:37-04:00"
title = "Refactoring as Discovery"
+++

Refactoring usually falls into two modes:

* **Small, local changes** that make later improvements possible
* **Large, structural changes** that improve the overall design

Before the big changes can happen, you often need to do a lot of small, mechanical edits. These help clean things up, but they also serve as a way to re-learn the codebase. What developers often won’t admit is that they usually _don’t know_ what the big change is going to be when they start. They just know the code isn’t right.

Refactoring, in that sense, is a kind of guided search. Each small edit acts like a probe. You try something, see how the code responds, and slowly uncover the real shape of the problem. It’s not about making the code perfect, it’s about making it legible enough to see what needs fixing.

This can be hard to justify. Leadership wants scoped work and clear outcomes, but that doesn't align with how messy systems work. If something feels off, the best starting point is often a few small cleanups. I usually carve out some time for "discovery" and start there.

In some teams, this approach also runs into resistance. Developers don’t always see the value in changing code that “works”. Without a bug or feature tied to it, refactoring can look like churn. In those cases, I sometimes do the cleanups anyway and then throw most of them away. But I keep the useful ones and fold them into the larger improvements. Even the discarded edits help clarify what’s wrong or where to go next.

If you were to graph the value of changes over time, you'd probably see a curve like this:
![](/images/refactor-rhythm.png)

* **Early**: quick, low-risk changes that help you get your bearings
* **Middle**: high-value structural edits, backed by smaller supporting tweaks
* **Late**: momentum slows, and you’re mostly just polishing

The tricky part is noticing when you've hit that final phase. It's easy to stay busy with small edits that feel productive but aren’t actually moving anything forward. Once the high-leverage work is done, it's usually time to stop.
