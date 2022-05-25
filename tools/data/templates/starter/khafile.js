// A new Kha project.
let project = new Project('{{game_name}}');

// Make it possible to have the same file name in different folders.
// You load an asset from a folder by replacing the / with _
project.addAssets('assets/**', {
  nameBaseDir: 'assets',
  destination: '{dir}/{name}',
  name: '{dir}/{name}'
});

// This is the Aeons icon by default. The icon get scaled depending on the platform.
// 1024px by 1024px is a good size to use.
project.icon = 'icon.png';

// Shader folder.
project.addShaders('shaders/**');

// Source folder.
project.addSources('source');

// Uncomment to enable lDtk support. Make sure you have both libraries installed with haxelib.
// project.addDefine('use_ldtk');
// project.addLibrary('ldtk-haxe-api');
// project.addLibrary('deepnightLibs');

// Uncomment to enable Nape support. Make sure you have nape-haxe4 installed with haxelib.
// project.addDefine('use_nape');
// project.addLibrary('nape-haxe4');

// Add the Aeons engine.
project.addLibrary('aeons');

resolve(project);
