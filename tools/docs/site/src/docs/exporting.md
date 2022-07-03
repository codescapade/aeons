---
layout: 'layouts/docs.html'
title: 'Exporting'
eleventyNavigation:
  key: 'Exporting'
  order: 2
---

## Exporting

`aeons build [platform]` to export to that platform. `aeons build html5` or `aeons build windows` for example.  
Exporting for most platforms will generate a project for that platform.  
Visual Studio project for windows, Xcode project for MacOS, iOs, tvOS etc. From there you can compile it to the native
executable.  
Html5 export will create a folder with an index.html, the javascript and the assets. you can upload to a
host or serve with a local server for testing.

Cross compiling is not supported in general.
- Windows export has to be exported on windows.
- MacOS, iOS, tvOS export has to be exported on MacOs.
- Linux export has to be exported on Linux.
- Android and Html5 can be exported from all three main platforms.

Available build platforms include:
- html5
- windows
- linux
- osx
- ios
- tvos
- android  

For example `aeons build html5` or `eaons build windows`.  

For all available platforms see [Kha](https://github.com/Kode/Kha){target="_blank" rel="noopener noreferrer"}. I haven't
tested all of them and some are not opens source and you need to be a registered developer (consoles).  

The [Kha wiki](https://github.com/Kode/Kha/wiki){target="_blank" rel="noopener noreferrer"} has some more
platform specific information.