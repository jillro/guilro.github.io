---
layout: post
title: Can we have a race condition in a single thread program ?
comments:
  - date: 2015-01-03T00:46:43.540Z
    author: Guillaume Royer
    content: "Lorem ipsum. Chocolat. \n\n Retour à la Ligne."
  - date: 2015-01-03T00:46:58.704Z
    author: Guillaume Royer
    content: "Lorem ipsum. Chocolat. \n\n Retour à la Ligne."
  - date: 2015-01-03T00:47:13.130Z
    author: Guillaume Royer
    content: "Lorem ipsum. Chocolat. \n\n Retour à la Ligne."
  - date: 2015-01-04T14:35:00.231Z
    author: Guillaume Royer
    content: "Lorem ipsum. Chocolat. \n\n Retour à la Ligne."
  - date: 2015-01-04T14:36:29.650Z
    author: Guillaume Royer
    content: "Lorem ipsum. Chocolat. \n\n Retour à la Ligne."
  - date: 2015-01-04T14:37:03.343Z
    author: Guillaume Royer
    content: "Lorem ipsum. Chocolat. \n\n Retour à la Ligne."
  - date: 2015-01-04T14:38:45.520Z
    author: Guillaume Royer
    content: "Lorem ipsum. Chocolat. \n\n Retour à la Ligne."

---

*If you don't know what race condition is, you can get an excellent explanation (with picture and all the stuff) on [Wikipedia](http://en.wikipedia.org/wiki/Race_condition#Software).*

I have seen recently many people making confusing statements about race conditions and threads. I had learned that race conditions could only occur between threads. But I saw code that looked like race conditions in event and asynchronous based languages, even if the program were single thread, like in Node.js, in GTK+, etc.

I tried to understand that and answer myself to my question (which I also did on [StackOverflow](http://stackoverflow.com/questions/21463377/can-we-have-race-conditions-in-a-single-thread-program)). **Can we have a race condition in a single thread program ?** I could not find any definitive answer to this question on the internet, so here is what I am think about this. I may be wrong, so please comment.

*All examples are in a fictional language very close to Javascript.*

<div class="well">
<ol>
<li>
<a href="#1">A race condition can only occur <b>between</b> two or more threads.</a> We <b>cannot</b> have race conditions <b>inside</b> a single thread process (for example in a single thread, non I/O doing program).
</li>
<li>
But a single thread program in many cases :
    <ol>
    <li>
    <a href="#2.1">give situations which looks similar to race conditions</a>, like in event based program with an event loop, but <b>are not real race conditions</b>.
    </li>
    <li>
    triggers race conditions between or with other thread(s), for example :
        <ul>
        <li>
        <a href="#2.2.1">other programs</a>, like clients
        </li>
        <li>
        <a href="#2.2.2">library threads or servers</a>
        </li>
        </ul>
    </li>
    </ol>
</li>
</ol>
</div>

#### I. Race conditions can only occur between two or more threads<a name="1">&nbsp;</a>
A race condition can only occur when two or more threads try to access a shared resource without knowing it is modified at the same time by **unknown insctructions** from the other thread(s). This gives an **undetermined result**. (This is really important.)  

A single thread process is nothing more than a sequence of **known instructions** which therefore results in a **determined result**, even if the execution order of instructions is not easy to read in the code.

#### II. We are not safe at all<a name="2">&nbsp;</a>

#### II.1. Situations similar to race conditions<a name="2.1">&nbsp;</a>

Many programming languages implements asynchronous programming features through *events* or *signals*, handled by a *main loop* or *event loop* which check for the event queue and trigger the listeners. Example of this are Javascript, libuevent, reactPHP, GNOME GLib... Sometimes, we can find situations which seems to be race conditions, **but they are not**.

The way the event loop is called is always **known**, so the result is **determined**, even if the execution order of instructions is not easy to read (or even cannot be read if you do not know the library).

Example:

````js
setTimeout(
  function() { console.log("EVENT LOOP CALLED"); },
  1
); // We want to print EVENT LOOP CALLED after 1 milliseconds

var now = new Date();
while(new Date() - now < 10) //We do something during 10 milliseconds

console.log("EVENT LOOP NOT CALLED");
````

in Javascript output is **always** (you can test in node.js) :

````
EVENT LOOP NOT CALLED
EVENT LOOP CALLED
````

because, the event loop is called when the stack is empty (all functions have returned).

Be aware that this is just an example and that in languages that implements events in a different way, the result might be different, but it would still be determined by the implementation.

#### II.2. Race conditions between or with other threads<a name="2.1">&nbsp;</a>
#### II.2.i. With other programs, like clients<a name="2.2.1">&nbsp;</a>

If other processes are requesting our process, that our program do not treat requests in an atomic way, and that our process share some resources between the requests, there might be a race condition *between clients*.

Example:

````js
var step;
on('requestOpen')(
  function() {
    step = 0;
  }
);

on('requestData')(
  function() {
    step = step + 1;
  }
);

on('requestEnd')(
  function() {
    step = step +1; //step should be 2 after that
    response(step);
  }
);
````

Here, we have a classical race condition setup. If a request is opened just before another ends, `step` will be reset to 0. If two `requestData` events are triggered before the `requestEnd` because of two concurrent requests, step will reach 3. *But this is because we take the sequence of events as undetermined.* We expect that the result of a program is most of the time undetermined with an undetermined input.

In fact, if our program is single thread, **given a sequence of events** the result is still always determined. The race condition is **between clients**.

There is two ways to understand the thing :

* We can consider clients as part of our program (why not ?) and in this case, our program is multi thread. End of the story.
* More commonly we can consider that clients are not part of our program. In this case they are just **input**. And what is important is that when we consider a program has a determined result or not, we do that with **input given**. Otherwise even the simplest program `return input;` would have a undetermined result.

Note that :

* if our process treat request in an atomic way, it is the same as if there was a *mutex* between client, and there is no race condition.
* if we can identify request and attach the variable to a request object which is the same at every step of the request, there is no shared ressource between clients and no race condition

#### II.2.ii. With library or server thread(s)<a name="2.2.2">&nbsp;</a>

In our programs, we often use libraries which spawn other processes or threads, or that just do I/O with other processes (and I/O is always undetermined).

Example :

````js
databaseClient.sendRequest('add Me to the database');

databaseClient.sendRequest('remove Me from the database');
````

This can trigger a race condition in an asynchronous library. This is the case if `sendRequest()` returns after having sent the request to the database, but before the request is really executed. We immediately send another request and we cannot know if the first will be executed before the second is evaluated, because database works on another thread. There is a race condition **between the program and the database process**.

But, if the database was on the same thread as the program (which in real life does not happen often) it would be impossible that sendRequest returns before the request is processed. (Unless the request is queued, but in this case, the result is still **determined** as we know exactly how and when the queue is read.)


#Conclusion

In short, single-thread programs are not free from trigerring race conditions. But they can only occur **with or between other threads of external programs**. The result of our program might be undetermined, because the input our program receive from those other programs is undetermined.
