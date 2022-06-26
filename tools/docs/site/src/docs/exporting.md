---
layout: 'layouts/docs.html'
title: 'Exporting'
eleventyNavigation:
  key: 'Exporting'
  order: 2
---

## Exporting

`aeons build [platform]` to export to that platform. Exporting for most platforms will generate a project for that
platform.  
Visual Studio project for windows, Xcode project for MacOS, iOs, tvOS etc. From there you can compile it to the native
executable.  
Html5 export will create a folder with an index.html, the javascript and the assets. you can upload to a
host or serve with a local server for testing.

Cross compiling is not supported in general.
- Windows export has to be exported on windows.
- MacOS, iOS, tvOS export has to be exported on MacOs.
- Linux export has to be exported on Linux.
- Android and Html5 can be exported from all three main platforms.