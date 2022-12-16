// This file has been generated using Aeons. Do no edit this file directly. Update the aeons.toml file instead.
let project = new Project('{{project_name}}');

project.addAssets('{{assets}}/**', {
  nameBaseDir: '{{assets}}',
  destination: '{dir}/{name}',
  name: '{dir}/{name}'
});

project.icon = '{{icon}}';

project.addShaders('{{shaders}}/**');

{{source}}

project.addLibrary('aeons');
{{libraries}}
{{defines}}
{{parameters}}
{{options}}

resolve(project);