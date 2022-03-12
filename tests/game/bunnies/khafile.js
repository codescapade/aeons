// A new Kha project.
let project = new Project('bunnies');

// Make it possible to have the same file name in different folders.
project.addAssets('assets/**', {
    nameBaseDir: 'assets',
    destination: '{dir}/{name}',
    name: '{dir}/{name}'
});

// Shader folder.
project.addShaders('shaders/**');

// Source folder.
project.addSources('../../../');
project.addSources('source');

resolve(project);