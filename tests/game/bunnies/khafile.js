let project = new Project('Bunnies');

project.addAssets('assets');
project.addSources('src');
project.addSources('../../../');

resolve(project);