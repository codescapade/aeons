let project = new Project('Basic');

project.addAssets('assets');
project.addSources('src');
project.addSources('../../../');

resolve(project);