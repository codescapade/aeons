let project = new Project('Docs');

project.addSources('../../');
project.addSources('Source');

project.addLibrary('nape-haxe4');

project.addParameter('-xml docs/docs.xml');
project.addParameter('-D doc-gen');
project.addParameter('--no-output');

resolve(project);