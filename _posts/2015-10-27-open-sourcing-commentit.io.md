---
layout: postCommentit
title: 'Open sourcing Comm(ent|it)'
---

Today, I am open sourcing [Comm(ent|it)](https://commentit.io). If you did not
[read my post](/2015/10/01/commentit.io.html) when I set it up a month ago, it
is a service for Github Pages which uses the Github API and Jekyll to help you
store visitors comments directly in your repository.

In the current state of the application, it is not really meant to be installed
and used in production on any server, as many things in the code are still very
specific to the instance runned on [commentit.io](https://commentit.io). Still,
if you want to do this, it can be done without to much work. I guess the final
goal is to make this a lot easier, to get the possibility to have a distributed,
self-hosted, customizable service to manage your comments in Github Pages.

For potential ameliorations to be shared, it is released under the
[AGPL](https://www.gnu.org/licenses/why-affero-gpl.en.html) license. You can
find the code on [Github](https://github.com/guilro/commentit), fork it, install
a development version in minutes, and start sending pull requests !
