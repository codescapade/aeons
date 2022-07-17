---
layout: 'layouts/docs.html'
title: 'New Project Setup'
eleventyNavigation:
  key: 'New project setup'
  parent: 'Getting Started'
  order: 2
---

## creating a new project
Run `aeons create [projectName]` in a terminal window to create a new project using the starter template. This will
create a folder with the name you chose in the current directory.  

### Files and folders in the project.
**.vscode** folder  
This contains some build tasks you can run from vscode and the debugger launch configuration.  

**assets** folder  
Here you can add all assets that are not sprite atlases. The sprite atlases will be automatically generated using Aeons
Atlas and put in this folder when you build the project.  

**atlasImages** folder  
Here you can add all images that should go in sprite atlases. The atlas config in the `aeons.toml` config file adds all
files into a single atlas by default.  

**build** folder  
This is where the exported game will be saved. Each platform goes in its own folder.  

**shaders** folder  
Here you can add custom glsl shaders that can get compiled to the correct shader language depending on the target
platform.  

**source** folder
Here you can add all the source code for your game.  


**aeons.toml** file
This is the configuration file for your project. You can see more info about it [here]({{ '/docs/getting_started/aeons_toml' | url }})

**icon.png**  
This icon will be used for the favicon in html5, menu and app icon on desktop and app icon on mobile.  
It will get scaled automatically. It is best to use a 1024 x 1024 icon for this.  

**khafile.js**  
This is the configuration file for the underlying Kha Framework this engine uses as its base. This is regenerated when
you build your project using the information from the `aeons.toml` config file.