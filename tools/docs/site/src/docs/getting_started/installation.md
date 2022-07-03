---
layout: 'layouts/docs.html'
title: 'Installation'
eleventyNavigation:
  key: 'Installation'
  parent: 'Getting Started'
  order: 1
---

## Installation
To use Aeons you need to have [Haxe](https://haxe.org){target="_blank" rel="noopener noreferrer"} installed.  
[Git](https://git-scm.com/){target="_blank" rel="noopener noreferrer"} and [Node.js](https://nodejs.org){target="_blank" rel="noopener noreferrer"} are required for the Kha framework Aeons is built on top of.  

After you have installed haxe you can install Aeons by opening a terminal and run:
`haxelib install aeons`  

If you want to get the latest version from github that is not stable you can run:
`haxelib git aeons https://github.com/codescapade/aeons`

After the installation you can run `haxelib run aeons setup` to download Kha and setup the 'aeons' command.
<br/>
<br/>

#### Command line commands
If you don't setup the aeons command in the step above you have to add `haxelib run` in front of these commands.
- `aeons help` - Shows the list of available commands.
- `aeons setup` - Run the aeons setup process.
- `aeons create [project name]` - Create a project with the chosen name in the current directory using the starter template.
- `aeons build [platform]` - Inside an Aeons project it will build the project for the chosen platform.
- `aeons atlas` Inside an Aeons project it will generate the sprite atlas from the `atlas.json` config.
- `aeons location [kha]` - Shows the aeons path. If kha is added it shows the kha path.
- `aeons update kha` - Update the Kha framework to the commit tested with Aeons.
- `aeons update latest-kha` - Update the Kha framework to the latest version. This could break Aeons if there were api changes in Kha.
