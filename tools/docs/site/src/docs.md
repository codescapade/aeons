---
layout: 'layouts/docs.html'
title: 'Aeons Documentation'
eleventyNavigation:
  key: 'Home'
  order: 0
---

#### This Engine is currently in an alpha state and things might change frequently.
## Welcome to Aeons

Aeons is a 2d game engine powered by [Kha](https://github.com/Kode/Kha) and written in [Haxe](https://haxe.org).  
Aeons doesn't have a build-in editor like some other engines. This is an engine for people who like to write code.  
There is support for external editors like [Tiled](https://www.mapeditor.org/) and [LDtk](https://ldtk.io/).

### Game Structure
![game structure]({{ '/static/docs/gameStructure.png' | url }})  
This is an overview of the structure of a game. A game has a scene stack where the top one is active. Inside a scene
there are functions to initialize the scene at the start and clean it up when you change to a different scene. There is also an update and render function you can use if you don't want to use the built-in ECS.  

If you do want to use the ecs you can add components to entities and add them to the scene and add systems to the scene.
The systems can have an update and/or render function depending on what you need them for. Entities and components can
have them as well if you just want to use the "System" part of ECS and just update the entities in the update and render
function of the scene.

### ECS
Aeons aims to be flexible. It uses an ECS pattern for most built-in systems, but you don't have to use it if you don't
want to.
You can use all of the built-in systems, some of them or none at all. You can build your game however you like.  

### Aeons class
The Aeons class is a static class that gives you access to a lot of the engine functionality. Some of these have systems
and components you can use like audio. Things like tweens and timers can be used from here directly.  
Things you can access from the Aeons class:
- **assets** - Loading and retrieving assets.
- **audio** - Playing sounds and music.
- **display** - Info about the screen and view sizes.
- **entities** - Entity and component manager. `Scene` and `Entity` have helper methods that use this in the background.
- **events** - The event manager. This works by adding listeners to the manager that have callbacks. You can emit events
from the events themselves. There can be global and scene listeners.
- **random** - Seeded random number generator.
- **storage** - Saving and loading game data.
- **systems** - The system manager for the systems in the active scene.
- **timers** - A timer manager for things you want to delay and/or repeat.
- **timeStep** - Get the current delta time, set the time scale and get the current fps. The update functions that have
dt use the value from this.
- **tween** - Tween manager. Create new tweens or manage current ones from here.


All these can be replaced with your own if you want by implementing their interface and using the `provide` function.
