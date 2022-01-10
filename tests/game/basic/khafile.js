let project = new Project('Basic');

project.addSources('src');
project.addSources('../../../');

resolve(project);