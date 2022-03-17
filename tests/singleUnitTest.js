let project = new Project('unit tests');
project.addAssets('testAssets');

project.addSources('../');
project.addSources('unit');

project.addLibrary('buddy');
project.addLibrary('nape-haxe4');

project.addParameter('--main RunSingleTest.hx');
project.addParameter('--debug');
resolve(project);