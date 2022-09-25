
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