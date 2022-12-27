![aeons_engine_logo](tools/data/logo/logo_640.png)
## This Engine is currently in an alpha state and things might change frequently.
<br/>
<br/>

## About this engine
Aeons is a 2D game engine built using the [haxe](https://haxe.org) programming language.
The underlying framework is [Kha](https://github.com/Kode/Kha).

I combined all the parts that I liked from game engines I used over the years.

It tries to give you options on how to create your game. You can choose to use or ignore them.

You can use the built-in ECS or just loop over entities yourself or both.

Entities can have components that are just data or you can put all functionality in them if you don't want to make a system for it.

A Scene has an update and render function. So do entities. Components can have them and systems as well. This way you have choose for yourself how to use them.

The built-in components and systems use ECS for the most part, but components have functions when I think it is easier that way.
<br/>
<br/>

## Examples (WIP)
[Aeons Examples](https://codescapade.github.io/aeons-examples)

## Docs (WIP)
[Aeons Docs](https://codescapade.github.io/aeons)

## Installation
To use Aeons you need to have Haxe installed. You can get it from [https://haxe.org](https://haxe.org)  
Nodejs is required for the build system. You can get it from [https://nodejs.org](https://nodejs.org)  
To install Aeons open a terminal and run: `haxelib install aeons`  

After the installation run `haxelib run aeons setup` to download Kha and setup the 'aeons' command.
<br/>
<br/>

## Commands
- `aeons help` - Shows the list of available commands.
- `aeons setup` - Run the aeons setup process.
- `aeons create [project name]` - Create a project with the chosen name in the current directory using the starter template.
- `aeons build [platform]` - Inside an Aeons project it will build the project for the chosen platform.
- `aeons atlas` Inside an Aeons project it will generate the sprite atlas from the `aeons.toml` config.
- `aeons location [kha]` - Shows the aeons path. If kha is added it shows the kha path.
- `aeons update kha` - Update the Kha framework to the commit tested with Aeons.
- `aeons update latest-kha` - Update the Kha framework to the latest version. This could break Aeons if there were api changes in Kha.

for example `aeons build html5` or `eaons build windows`  
For available platforms see [Kha](https://github.com/Kode/Kha)
<br/>
<br/>

## Api Documentation (WIP)
[https://codescapade.github.io/aeons/api](https://codescapade.github.io/aeons/api)  
<br/>

## Visual studio code extension
When writing code in visual studio code you can use the [Kha Extension Pack](https://marketplace.visualstudio.com/items?itemName=kodetech.kha-extension-pack) to get auto completion and debugging support.  

Set the `kha.khaPath` in the vscode settings to the kha folder used by Aeons to use the version that has been tested with Aeons.  

To find the location type `aeons location kha` when you have the aeons command installed. It is in the lib folder inside the Aeons library.
<br/>
<br/>

## Running unit tests
To run the unit tests, Aeons expects that `buddy` is installed with haxelib.  
The `runUnitTests` and `runSingleUnitTest` commands in the tests folder require a path to an ffmpeg executable as argument to convert some of the test assets.


## Building api docs
The api docs are generated using `dox` that needs to be installed with haxelib.  
The `buildApi` command in the tools/docs folder can be used the generate the api docs in the docs/api folder.