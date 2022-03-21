let project = new Project('Basic');

project.addAssets('assets');
project.addSources('src');
project.addSources('../../../');

project.addLibrary('ldtk-haxe-api');
project.addDefine('use_ldtk');

resolve(project);