---
title: Exploring Game Development at Coventry University's Summer School
published: 2024-08-05
description: "I share my experience attending Coventry University's Summer School in July 2024. Over four weeks, I learned about various aspects of game development, culminating in a game jam as the program's finale. This post provides a week-by-week breakdown of the program and my thoughts on each part."
image: 'https://r2.sakurakat.systems/covuni-experience-banner.jpg'
tags: ['Programming', 'Game Development', 'Unity', "CSharp", 'retrospection']
category: 'Programming'
draft: false
---

# Table of Contents
<!-- TOC -->
* [Table of Contents](#table-of-contents)
* [Week 1](#week-1)
  * [Physics](#physics)
  * [Animation](#animation)
  * [My thoughts](#my-thoughts)
* [Week 2](#week-2)
  * [Navigation](#navigation)
  * [Finite State Machine (FSM)](#finite-state-machine-fsm)
  * [My thoughts](#my-thoughts-1)
* [Week 3](#week-3)
  * [High Concept Document (HCD)](#high-concept-document-hcd)
  * [Game Mechanics](#game-mechanics)
  * [Level Design and Storytelling with Games](#level-design-and-storytelling-with-games)
* [Week 4 and wrapping up](#week-4-and-wrapping-up)
* [What to expect next](#what-to-expect-next)
* [Citations](#citations)
* [Footnotes](#footnote-label)
<!-- TOC -->


In July 2024,
I had the privilege
of attending [Coventry University's Summer School](https://www.coventry.ac.uk/study-at-coventry/summer-schools/)
[^search-disclaimer]
organized by [Vishwaniketan Incubation Center](https://vic.vishwaniketan.edu.in/)
(VIC from hereon).
This experience lasted for 4 weeks and was
sold to us by VIC as "[International Summer Internship](https://ugfellowship.vishwaniketan.edu.in/)."
Once we got to the UK, it turned out to be summer school, which made more sense to me than an internship.

This blog post covers some of what I learned and did during the summer school.
Note that this is from the perspective of someone who is already familiar with the basics of Godot enough
to participate in Game Maker's Toolkit's Game Jam in 2023 [^gmtk2023-itchio] [^gmtk2023-github].
::github{repo="pawarherschel/GMTK2023"}
I also know Unity on a surface level due to uploading avatars and making minor changes to them for VRChat.
I feel like the best way to structure this blog post would be to tell you what I did each week.
However, I will avoid going into the details about each topic as
that would entail  copying their presentation word-for-word.

---

# Week 1

For the first week, we got introduced to the Unity game engine from scratch.
The professors didn't expect you to know anything about Unity,
so we started with the UI of the editor, first lines in C# for Unity,
how to run the games,
how to fix Visual Studio if the LSP [^LSP]
(Language Server Protocol [^LSP]) 
doesn't work [^why-lsp-important],
and so on.

## Physics

After that, we moved on to the role of physics in games and why it's important.
The professors then explained the key terms related to physics in Unity and where they can be found.
They also explained how colliders are done in professional games. 
For me, the most significant part of this day was the event functions required to make colliders (and triggers) useful.
As the lab task of the day, we made a red square jump and move on a platform.

As an extra challenge, we got a skeleton pinball project.
In the project, we had to configure some parameters and write some scripts as glue code.
I'd add a GIF of me playing the game, but I performed the task on the university computer. 

## Animation

On the next day we were taught how to use the animation system in Unity.
They started by explaining what a rig is for 3D animations and how 3D models are animated using it.
Then, we were given a rundown on how to *actually* use the animation system,
that is, animator controller, animation clips,
the transitions required as glue, animation parameters, animator component, and finally, how to use the animator in code.
We then moved on to 2D animation by using sprites and how to make them from spritesheets. 

As for the lab task, we made a Flappy Bird clone where the background moves and loops infinitely.
> ![me attempting to play Flappy Bird and losing on the first pipe](https://r2.sakurakat.systems/covuni-experience--flappy-bird.gif)

We also animated a Lara Croft inspired 2D character.
> ![Lara Croft inspired 2D character](https://r2.sakurakat.systems/covuni-experience--2d-character.png)

We sliced her body parts from a spritesheet
> ![character spritesheet](https://r2.sakurakat.systems/covuni-experience--2d-character-spritesheet.png)

and animated in a way where it looked like her body parts were connected using joints without using joints. 
> ![2d animation](https://r2.sakurakat.systems/covuni-experience--2d-animation.gif)

Thus, they managed to teach the three core concepts required to make games. 

## My thoughts

All in all, to my surprise, the professors could condense down the content and even with that,
we were still able to complete the lab tasks during the afternoon sessions,
and we had excess time, at least for the first week (lol).

I anticipated that we would have plenty of free time during the first week, and I was correct. 

# Week 2

The focus for the second week was AI used in games.
The major reason why the specific AI techniques used is their performance cost.
They're proven to work well on all kinds of hardware while also giving the illusion of intelligence.

## Navigation

Navigation is a big part
of making NPCs
seem intelligent by making them follow a path towards some target without getting stuck on a corner or on some object.
The default algorithm for pathfinding in Unity is A* (tangent [^tangent-A*]).

Unity uses NavMesh for navigation.
The topics they covered were NavMesh, Off-Mesh Link, NavMesh Obstacle, and NavMesh Agent.
They showed us how to generate a NavMesh by baking it in the editor,
made a NavMesh Agent, and made the agent move to the target location by writing some glue code.
Then the professors taught about NavMesh Obstacles, why, and how to use it.

The lab task for the day was to make a character that pathfinds to a sphere using the NavMesh System.
For the challenge, we had to make it so that you can move the target sphere, and the character will still follow it.
> ![the navmesh project](https://r2.sakurakat.systems/covuni-experience--navmesh-project.gif)

I wanted to make the character use automatically generated Off Mesh Links, 
and I did it by changing the cost for surfaces to wacky numbers.
:::note[the wacky numbers]

![the hacky numbers](https://r2.sakurakat.systems/covuni-experience--navmesh-hack.png)

:::
> ![pathfinding using weird numbers](https://r2.sakurakat.systems/covuni-experience--navmesh-hack.gif)

## Finite State Machine (FSM)

The second AI technique we learned about was FSM.
The professors gave us examples of what good AI and bad AI are
by showing us example videos and explaining why they're good or bad.
They then explained where exactly FSM fits into the pipeline
and gave an example of a rudimentary way to implement FSM by chaining conditional statements.

To me, FSM is interesting because if the language has a strong type system and supports generics,
then it's possible to get a type-safe FSM. 
The technique mentioned in the last sentence is called typestate [^wikipedia-typestate] [^rust-book-typestate], 
which I have implemented before in rust.
Typestate pattern can be used in C# as well [^stack-overflow-c-sharp-typestate] [@so_typestate_c_sharp],
however, I didn't use it myself due to how much time it would have required.

We've already used FSMs in Unity, the animation tree is an example of FSM.
The states are the available animations,
the parameters along with the conditions are the state transitions, and the animation being played is the current state.

FSMs are also an example of event driven programming [^wikipedia-event-driven-fsm], 
which you might be familiar with if you use JavaScript/Typescript/ECMAScript.
I have used Event-Driven Programming [^wikipedia-event-driven-programming]
in Godot with the help of [signals](https://docs.godotengine.org/en/stable/classes/class_signal.html) 
([Godot documentation for Using Signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html)).
They made connecting scripts really easy.
Unity also has an [Event System](https://docs.unity3d.com/560/Documentation/Manual/EventSystem.html),
but I didn't feel confident in myself
to learn how to make events and connect scripts using them by using the Unity docs.
(tangent [^tangent-documentation]) (another tangent lol [^tangent-composition-inheritance])

There were three lab tasks we had to do,
Implementing a basic If/else FSM,
Implementing an FSM using Rabin events, and
Implementing a FSM using the State Pattern.
The project we made was controlling a cat,
and when the cat is in a certain radius of the chicken, the chicken tried to flee.
> ![the cat and chicken game](https://r2.sakurakat.systems/covuni-experience--cat-and-chicken.gif)

The challenge was creating a first-person controller,
which can shoot spheres, and a cube that will follow the player;
once the cube is shot, it will stop following after the player.
> ![the fps thingy](https://r2.sakurakat.systems/covuni-experience--fps-thingy.gif)

## My thoughts

Week 2 was interesting, it's where the most of the learning happened for me,
and it was the most information dense week.
While I was familiar with (or even used) the techniques,
it was still fun to learn about the history, and the reason techniques exist.
This is the reason I love the academic setting.

# Week 3

The third week was all about game design and how it's done in the industry.
I'm not a creative person, I'm a developer.
I can take in requirements and turn them into code to the best of my ability.
However, while I can add game mechanics and build a game around them,
I struggle with making the experience genuinely fun.But it's important to know
what the designers do and what their struggles are.
That way I can contribute more to the team while also somewhat bridging the gap between developers and designers.

While the second week was all the things I wanted to learn, the third week wasn't as interesting for me. 

## High Concept Document (HCD)

We made an HCD for a game idea we got from [Game Idea Generator](https://ygd.bafta.org/resources/game-idea-generator).
We brainstormed about some game ideas,
but due to me being an idiot, I used an online md editor and didn't save the file.

## Game Mechanics

I was going to put the document I made for the [SCP-3008](https://scp-wiki.wikidot.com/scp-3008) 
(the IKEA store) [@mortos_scp_3008] inspired game, but due to technical issues I wasn't able to save the file...
The premise for the game was that you're a D-Class personnel who had to get inside SCP-3008, and 
your objective is to bring back information regarding the structure and the creatures. 
Due to the scary nature of SCP-3008, it would be a horror game.

You can only see in a cone in front of you, 
but you can hear the creatures.
According to the article, the creatures say lines such as 
"[The store is now closed, please exit the building](https://scp-wiki.wikidot.com/scp-3008#:~:text=The%20store%20is%20now%20closed%2C%20please%20exit%20the%20building)".
These voice lines act as information regarding where the creatures are in relation to the player.

During the day phase, you prepare for the night (kinda obvious I think).
One of the core mechanics are randomly generated areas with objects which might help you survive the night, and 
you also have the items from previous days.
After you survive the night, you move to a different area.

As for the difficulty increase, your cone of vision keeps shrinking;
however, the amplitude of the voice lines stays constant.

## Level Design and Storytelling with Games

The lab tasks for level design and storytelling were connected, so I'm going to write them as one. 
I made the first level for a puzzle game "inspired"
by [Crazy Machines](https://store.steampowered.com/app/18420/Crazy_Machines/) 
(tangent [^tangent-crazy-machine]).

Fortunately, I had solved my technical issue, and I was able to save the task output.

The premise of the game is, 
you’re a small child who can see fae-creatures.
The fae creatures are trapped in the human world and your task is to free them from their "cages".
Each cage has a weakness, and each item is associated with a material.
To free the fae from the cage, you need to collide an object, which is made of the material it's weak to.
To know what's weak to what, you will need to listen to the stories and fairytales that are part of the puzzles. 

> ![Level Design](https://r2.sakurakat.systems/covuni-experience--level-design.png)

Legend for the image:
- Red Rectangles: different sections of the UI
- Magenta Rectangles: gameplay related UI 
- Lime-Green Lines: platforms
- Yellow Circles: metal ball
- Brown Rectangles: books, which will act as dominoes
- Magenta Diamond: the final goal
- Purple Rectangle: the area where you're allowed to place "blocks" from your inventory.

```markdown
Game Window: where the puzzle takes places
Inventory: available "blocks" for the puzzle
Notepad: for writing notes, which persist across puzzles,
and also exist during fairy tale time

level 1: hello world

start
metal ball rolls down
hits the book
book hits other book like dominoes
last book hits another metal ball
the metal ball hits the goal
win

the inventory will have the initial metal ball
the allow area is the only place where you can initially put the ball
```

# Week 4 and wrapping up

During the fourth week, as a culmination of all our efforts and knowledge, we participated in a game jam hosted by
[Mohilly](https://mohilly.itch.io/),
[ae2720](https://ae2720.itch.io/),
[ae2791](https://ae2791.itch.io/), and 
[ab8809](https://ab8809.itch.io/) 
at [itch.io](https://itch.io/jam/summer-school-24).

The requirements for the game jam were:
- 2D Platformer
    - Create a game in the 2D platformer genre, focusing on movement, jumping, and
      exploration. 
- Continuous Change
    -  Implement mechanics that highlight the theme. This could include
       changing environments, shifting levels, evolving abilities, or any other creative interpretation.

I teamed up with Shashank Bhave
([GitHub](https://github.com/CAPTAINxNEMO), [LinkedIn](https://www.linkedin.com/in/shashank-bhave/)) for the game jam.
We satisfied the requirements by creating a 2D platformer where every level fits in one screen. 
The theme of `Continuous Change` was incorporated by changing the player character and their abilities every few seconds.

We named the game `Fractured Elements`.
It's available to download at [itch.io](https://pawarherschel.itch.io/fractured-elements),
and the source code is available on [GitHub](https://github.com/pawarherschel/CovUniGJ2024).

::github{repo="pawarherschel/CovUniGJ2024"}

(yes, I'm __very__ creative with naming)

The level design was done by Shashank, while I tried my best to implement the themes in code.
He designed the level, found the game art, and made the level using tilemaps.

> ![the complete map](https://r2.sakurakat.systems/covuni-experience--map.png)

:::note[room 1]
![room 1](https://r2.sakurakat.systems/covuni-experience--map--room-1.png)
:::

:::note[room 2]
![room 2](https://r2.sakurakat.systems/covuni-experience--map--room-2.png)
:::

:::note[room 3 (boss)]
![room 3 (boss)](https://r2.sakurakat.systems/covuni-experience--map--room-3-boss.png)
:::

The main character has the power to control "elements"; however, they don't have control over their powers.
Due to that, they keep switching between forms.
To control their powers, they need to harvest power cores from ancient golems.

To do so, the player must deal with the constant switching between forms and weapons while also platforming. 

# What to expect next

In my next blog post, I want to go into how the game works and Shashank will expand on how he made the level design.

---

# Citations

[^ref]

---

[^tangent-documentation]: The documentation for both Godot and Rust is really good and easy to understand. But, Unity's and Java's official documentation is scary, and it was hard for me.
[^search-disclaimer]: At the time of writing, this comes up when you search for "Coventry University summer school"
[^LSP]: It's the thing that gives you the red squiggly line in your editor
[^why-lsp-important]: This turned out to be important since the LSP kept breaking for us lol
[^tangent-A*]: I learned A* by watching [A* Pathfinding Algorithm (Coding Challenge 51 - Part 1)](https://www.youtube.com/watch?v=aKYlikFAV4k) by [The Coding Train](https://www.youtube.com/@TheCodingTrain).<iframe width="1237" height="696" src="https://www.youtube.com/embed/aKYlikFAV4k" title="A* Pathfinding Algorithm (Coding Challenge 51 - Part 1)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> While it's on the longer side and has three parts, I do recommend watching it since Daniel Shiffman made it easy to understand, and, also implemented it.
[^tangent-crazy-machine]: I have fond memories of playing the game when i was small. It was very fun and I spent hours messing around in the sandbox  
[^gmtk2023-itchio]: my submission to the game jam https://pawarherschel.itch.io/cosmos-conquerors
[^gmtk2023-github]: source code for Cosmos Conquerors https://github.com/pawarherschel/GMTK2023  
[^wikipedia-typestate]: Wikipedia article for Typestate analysis https://en.wikipedia.org/wiki/Typestate_analysis
[^rust-book-typestate]: Encoding States and Behavior as Types from The Rust Programming Language book https://doc.rust-lang.org/book/ch17-03-oo-design-patterns.html#encoding-states-and-behavior-as-types  
[^stack-overflow-c-sharp-typestate]: Type-state pattern in C# https://stackoverflow.com/questions/78677699/type-state-pattern-in-c-sharp
[^wikipedia-event-driven-fsm]: Event-driven finite-state machine https://en.wikipedia.org/wiki/Event-driven_finite-state_machine
[^wikipedia-event-driven-programming]:  Event-driven programming https://en.wikipedia.org/wiki/Event-driven_programming
[^tangent-composition-inheritance]: The professors recommended (or at least they only taught) us to make an abstract class with all the functions and then use inheritance to create actual classes for the states. Coming from Rust, composition would have been my choice rather than inheritance.