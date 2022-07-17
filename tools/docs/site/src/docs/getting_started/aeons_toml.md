---
layout: 'layouts/docs.html'
title: 'Aeons.toml'
eleventyNavigation:
  key: 'aeons.toml config'
  parent: 'Getting Started'
  order: 4
---

## The aeons configuration file
The configuration file used to build your project is called `aeons.toml`. [TOML](https://toml.io) is a bit like YAML,
but without all the indentation. This file is used to create the sprite atlases and build your project.  

For more info on the atlas packing you can look in the [aeons atlas](https://github.com/codescapade/aeons-atlas) repo.


Here is an explanation of what you can configure:
``` toml
[aeons] # this goes at the top so the build knows this is an aeons project.

# The name for this project.
# This will be used in the title bar or browser tab. This is the only mandatory field.
projectName = "aeons game"

# The folder in your project where the shaders are.
# Defaults to 'shaders' if you don't set it.
shaderFolder = "shaders"

# The folder with all your haxe code.
# Default to 'source' if you don't set it.
sourceFolder = "source"

# The icon for you game. It gets scaled depending on the platform for app icons, favicon etc.
# 1024px by 1024px is a good size to use.
icon = "icon.png"

# A list of haxe libraries you are using in your project.
libraries = []

# A list of haxe defines for conditional compilation.
# The ones used in #if #end in you haxe code.
defines = []

# A list of haxe parameters like -debug  -dce.
parameters = []

# Html5 specific settings.
[aeons.html5]
disableContextMenu = true # Disable right click menu.
canvasId = "" # The id tag on the canvas in the html file. Default is khanvas.
scriptName = "" # The name of the javascript file. Default is kha.js.
width = 800 # The canvas width in pixels. Default = 800.
height = 600 # The canvas height in pixels. Default = 600.

# Android specific settings.
[aeons.android]
packageName = "com.aeons.game" # Android package name.
versionCode = 1 
versionName = "1.0"

#https://developer.android.com/guide/topics/manifest/activity-element.html#screen
screenOrientation = "portrait"
permissions = [] # device permissions needed.

# https://developer.android.com/guide/topics/manifest/manifest-element#install
installLocation = ""

# https://developer.android.com/guide/topics/manifest/meta-data-element
metadata = []

# same as <meta-data android:name="disableStickyImmersiveMode" android:value="true"/>
disableStickyImmersiveMode = true
globalBuildGradlePath = "gradle-path"
proguardRulesPath = "rules-path"

# for files in Android Studio project-level dir
customFilesPath = "custom-files-path"

[aeons.ios]
bundle = "com.aeons.game" # ios bundle identifier.
organizationName = "Aeons" # 
developmentTeam = "" # ios Development team identifier 
version = "1.0"
build = 1

# Sprite atlas config. You can have multiple of these in the project
# if you want to create more than one sprite atlas.
[[atlas]]
name = "atlas" # The name of the atlas image and data file.
saveFolder = "assets" # The folder to save the atlas in.
folders = [] # A list of folders that have images for the atlas. Not recursive.
files = [] # A list of image files for the atlas if you don't want to use a whole folder.
trimmed = true # Should the excess white space be trimmed off.
extrude = 1 # Number of pixels to extrude the images. For when you get artifacts at the edges.
packMethod = "optimal" # basic or optimal packing.

```
