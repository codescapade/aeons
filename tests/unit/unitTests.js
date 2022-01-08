let project = new Project('unit tests');
// project.addAssets('Assets');
// project.addAssets('TestAssets');
project.addSources('');
project.addSources('tests/unit');
project.addLibrary('buddy'); // my own git version
// project.addLibrary('nape-haxe4');
project.addLibrary('mockatoo'); // my own git version
project.addParameter('--main RunTests.hx');
project.addParameter('--debug');
resolve(project);