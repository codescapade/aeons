let project = new Project('Basic');

project.addAssets('assets');
project.addSources('src');
project.addSources('../../../');
project.addLibrary('nape-haxe4');

resolve(project);