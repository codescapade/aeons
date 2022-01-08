# Aeons 

## This game engine is in active development and not ready for use yet.
Aeons is a game engine built using the [haxe](https://haxe.org) programming language.
The underlying framework is [Kha](https://github.com/Kode/Kha).

I combined all the parts that I liked from game engines I used over the years.

It tries to give you options on how to create your game. You can choose to use or ignore them.

You can use the built-in ECS or just loop over entities yourself or both.

Entities can have components that are just data or you can put all functionality in them if you don't want to make a system for it.

A Scene has an update and render function. So do entities. Components can have them and systems as well. This way you have choose for yourself how to use them.

The built-in components and systems use ECS for the most part, but components have functions when I think it is easier that way.


### Running unit tests
To run the unit tests, Aeons expects that mockatoo and buddy are installed with haxelib from the following urls:

Mockatoo: [https://github.com/codescapade/mockatoo](https://github.com/codescapade/mockatoo)  
Buddy: [https://github.com/codescapade/buddy](https://github.com/codescapade/buddy)