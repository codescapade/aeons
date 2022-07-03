---
layout: 'layouts/docs.html'
title: 'VsCode Extensions'
eleventyNavigation:
  key: 'VSCode Extensions'
  parent: 'Getting Started'
  order: 3
---

## VSCode extensions
If you use Visual Studio Code as your code editor there are a few extensions that can make things a bit easier.  
Installing the [Kha extension pack](https://marketplace.visualstudio.com/items?itemName=kodetech.kha-extension-pack){target="_blank" rel="noopener noreferrer"}
will install the extensions needed give you highlighting and autocomplete for Haxe. It also installs the electron
extension for fast testing and debugging using html5.  

Set the `kha.khaPath` in the vscode settings to the Kha folder used by Aeons.

To find the location of the Kha folder, type `aeons location kha` when you have the `aeons` command installed. It is in
the lib folder inside the Aeons library folder. 