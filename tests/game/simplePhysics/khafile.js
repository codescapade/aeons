// This file has been generated using Aeons. Do no edit this file directly. Update the aeons.toml file instead.
let project = new Project('simplePhysics');

project.addAssets('assets/**', {
  nameBaseDir: 'assets',
  destination: '{dir}/{name}',
  name: '{dir}/{name}'
});

project.icon = 'icon.png';

project.addShaders('shaders/**');

project.addSources('source');


project.addLibrary('aeons');






resolve(project);