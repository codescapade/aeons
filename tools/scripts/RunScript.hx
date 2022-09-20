package;

import haxe.Exception;
import haxe.Json;
import haxe.io.Path;

import haxetoml.TomlParser;

import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;

class RunScript {
  static final testedKhaCommit = '2de99e5';

  public static function main() {
    final args = Sys.args();
    final wd = args.pop();

    final version = getVersion();
    // aeons help
    if (args.length == 1 && args[0] == 'help' || args[0] == 'h') {
      printLogo(version);
      showHelp();
      Sys.exit(0);
      // aeons setup
    } else if (args.length == 1 && args[0] == 'setup') {
      setupAeons(wd);
      Sys.exit(0);
    } else if (args.length == 1 && args[0] == 'atlas') {
      generateAtlas(wd);
      Sys.exit(0);
      // aeons alias
    } else if (args.length == 1 && args[0] == 'alias') {
      setupAlias();
      Sys.exit(0);
      // aeons create [project_name]
    } else if (args.length > 1 && args[0] == 'create') {
      createProject(wd, args[1]);
      Sys.exit(0);
      // aeons build [platform]
    } else if (args.length > 1 && args[0] == 'build') {
      args.shift();
      final config = readConfig(wd);
      if (config == null) {
        Sys.exit(1);
      } else {
        if (args.indexOf('--no-atlas') == -1 && config.atlas != null) {
          generateAtlas(wd);
        } else {
          args.remove('--no-atlas');
        }
        var khafileSuccess = writeKhafile(wd, config, args[0].toLowerCase());
        if (khafileSuccess) {
          Sys.exit(build(wd, args));
        } else {
          Sys.exit(1);
        }
      }
      // aeons location [kha]
    } else if (args.length >= 1 && args[0] == 'location') {
      final haxelibPath = getHaxelibPath('aeons');
      if (args.length > 1 && args[1] == 'kha') {
        final khaPath = Path.join([haxelibPath, 'lib/Kha']);
        Sys.println('kha path: ${khaPath}');
      } else {
        Sys.println('aeons path: ${haxelibPath}');
      }
      Sys.setCwd(wd);
      Sys.exit(0);
    } else if (args.length == 2 && args[0] == 'update') {
      if (args[1] == 'kha') {
        updateKha(wd);
        Sys.exit(0);
      } else if (args[1] == 'latest-kha') {
        updateKha(wd, true);
        Sys.exit(0);
      }
    }

    printLogo(version);
    Sys.println('Use \'aeons help\' for a list of commands.');
    Sys.exit(0);
  }

  /**
   * Find the location of a haxelib library.
   * @param name The library to find.
   * @return The location path.
   */
  static function getHaxelibPath(name: String): String {
    final proc = new Process('haxelib', ['path', name]);
    var result = '';

    try {
      var previous = '';
      while (true) {
        final line = proc.stdout.readLine();
        if (line.startsWith('-D $name')) {
          result = previous;
          break;
        }
        previous = line;
      }
    } catch (e:Dynamic) {}

    proc.close();

    return result;
  }

  static function getVersion(): String {
    var libPath = getHaxelibPath('aeons');
    var haxelib = Path.join([libPath, 'haxelib.json']);
    var json = Json.parse(File.getContent(haxelib));

    return json.version;
  }

  /**
   * Run a Sys command and restore the working directory after.
   * @param path The path to run the command in.
   * @param command The command to run.
   * @param args A list of command parameters.
   * @param throwErrors Show this throw errors.
   * @return The command status. 0 is success.
   */
  static function runCommand(path: String, command: String, args: Array<String>, throwErrors = true): Int {
    var currentPath = '';
    if (path != null && path != '') {
      currentPath = Sys.getCwd();

      try {
        Sys.setCwd(path);
      } catch (e:Dynamic) {
        Sys.println('cannot set current working directory to %{path}.');
      }
    }

    var result = Sys.command(command, args);
    if (currentPath != '') {
      Sys.setCwd(currentPath);
    }

    if (result != 0 && throwErrors) {
      Sys.exit(1);
    }

    return result;
  }

  static function setupAeons(workingDir: String) {
    downloadKha(workingDir);
    setupAtlas();
    setupAlias();
  }

  static function setupAtlas() {
    final platform = Sys.systemName();
    final haxelibPath = getHaxelibPath('aeons');
    if (platform == 'Mac') {
      final path = Path.join([haxelibPath, 'tools/atlas/AeonsAtlasMac']);
      Sys.command("chmod", ["+x", path]);
    } else if (platform == 'Linux') {
      final path = Path.join([haxelibPath, 'tools/atlas/AeonsAtlasLinux']);
      Sys.command("chmod", ["+x", path]);
    }
  }

  /**
   * Copy aeons.bat or aeons.sh to the haxe folder so you can run the aeons command.
   */
  static function setupAlias() {
    while (true) {
      Sys.println('');
      Sys.println('Do you want to install the "aeons" command? [y/n]?');

      return switch (Sys.stdin().readLine()) {
        case "n", "No":
          return;
        case "y", "Yes":
          break;

        default:
      }
    }

    final platform = Sys.systemName();
    final binPath = platform == 'Mac' ? "/usr/local/bin" : "/usr/bin";

    if (platform == 'Windows') {
      var haxePath: String = Sys.getEnv('HAXEPATH');
      if (haxePath == null || haxePath == '')
        haxePath = 'C:\\HaxeToolkit\\haxe\\';

      final destination = Path.join([haxePath, 'aeons.bat']);
      final source = Path.join([getHaxelibPath('aeons'), 'tools/data/bin/aeons.bat']);

      if (FileSystem.exists(source)) {
        File.copy(source, destination);
      } else {
        throw 'Could not find the aeons alias script.';
      }
    } else {
      final source = Path.join([getHaxelibPath('aeons'), 'tools/data/bin/aeons.sh']);

      if (FileSystem.exists(source)) {
        Sys.command("sudo", ["cp", source, binPath + "/aeons"]);
        Sys.command("sudo", ["chmod", "+x", binPath + "/aeons"]);
      } else {
        throw 'Could not find the aeons alias script.';
      }
    }
    Sys.println('The "aeons" command has been added to path.');
  }

  /**
   * Download Kha. Overwrite the existing installation if it exists.
   */
  static function downloadKha(workingDir: String) {
    final libPath = Path.join([getHaxelibPath('aeons'), 'lib']);
    final path = Path.join([libPath, 'Kha']);

    if (FileSystem.exists(path)) {
      Sys.println('${path} already exists. Updating Kha.');
      updateKha(workingDir);
      return;
    }

    Sys.println('Downloading Kha to aeons/lib/Kha');
    if (!FileSystem.exists(libPath)) {
      FileSystem.createDirectory(libPath);
    }

    Sys.setCwd(libPath);
    final platform = Sys.systemName();

    runCommand('', 'git', ['clone', 'https://github.com/Kode/Kha']);
    runCommand('Kha', 'git', ['checkout', testedKhaCommit]);

    if (platform == 'Windows') {
      runCommand('Kha', 'get_dlc', []);
    } else {
      runCommand('Kha', './get_dlc', []);
    }

    Sys.println('Download of Kha completed');
  }

  static function updateKha(workingDir: String, latest = false) {
    final libPath = Path.join([getHaxelibPath('aeons'), 'lib']);
    final path = Path.join([libPath, 'Kha']);

    if (!FileSystem.exists(path)) {
      Sys.println('${path} does not exist. Downloading Kha.');
      downloadKha(workingDir);
      return;
    }
    Sys.setCwd(path);
    final platform = Sys.systemName();

    Sys.println('pulling git');
    runCommand('', 'git', ['pull', 'origin', 'main']);
    if (!latest) {
      Sys.println('pulling checking out ${testedKhaCommit}');
      runCommand('', 'git', ['checkout', testedKhaCommit]);
    }

    Sys.println('Running get_dlc');
    if (platform == 'Windows') {
      runCommand('', 'get_dlc', []);
    } else {
      runCommand('', './get_dlc', []);
    }

    Sys.println('Kha update completed');
    Sys.setCwd(workingDir);
  }

  /**
   * Aeons build command that uses Kha to build the project.
   * @param projectDir The project directory. 
   * @param args Arguments for khamake. Must have at least the platform.
   */
  static function build(projectDir: String, args: Array<String>) {
    Sys.setCwd(projectDir);
    Sys.println('Starting build...');

    final haxelibPath = getHaxelibPath('aeons');
    final khaPath = Path.join([haxelibPath, 'lib/Kha']);
    final makePath = Path.join([khaPath, 'make.js']);
    args.unshift(makePath);
    return runCommand('', 'node', args);
  }

  /**
   * Generate a sprite atlas using AeonsAtlas.
   * @param projectDir The project directory.
   */
  static function generateAtlas(projectDir: String) {
    Sys.setCwd(projectDir);
    final platform = Sys.systemName();

    final haxelibPath = getHaxelibPath('aeons');

    var appPath = '';
    if (platform == 'Windows') {
      appPath = Path.join([haxelibPath, 'tools/atlas/AeonsAtlasWin.exe']);
    } else if (platform == 'Mac') {
      appPath = Path.join([haxelibPath, 'tools/atlas/AeonsAtlasMac']);
    } else if (platform == 'Linux') {
      appPath = Path.join([haxelibPath, 'tools/atlas/AeonsAtlasLinux']);
    }

    if (appPath == '') {
      Sys.println('Aeons Atlas executable not found. Skipping atlas generation.');
    } else {
      if (FileSystem.exists('aeons.toml')) {
        runCommand('', appPath, ['aeons.toml']);
      } else {
        Sys.println('No aeons.toml file found. Cannot generate atlas.');
      }
    }
  }

  static function printLogo(version: String) {
    Sys.println('');
    Sys.println('   @@@@@@   @@@@@@@@   @@@@@@   @@@  @@@   @@@@@@ ');
    Sys.println('  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@ @@@  @@@@@@@ ');
    Sys.println('  @@!  @@@  @@!       @@!  @@@  @@!@!@@@  !@@     ');
    Sys.println('  !@!  @!@  !@!       !@!  @!@  !@!!@!@!  !@!     ');
    Sys.println('  @!@!@!@!  @!!!:!    @!@  !@!  @!@ !!@!  !!@@!!  ');
    Sys.println('  !!!@!!!!  !!!!!:    !@!  !!!  !@!  !!!   !!@!!! ');
    Sys.println('  !!:  !!!  !!:       !!:  !!!  !!:  !!!       !:!');
    Sys.println('  :!:  !:!  :!:       :!:  !:!  :!:  !:!      !:! ');
    Sys.println('  ::   :::   :: ::::  ::::: ::   ::   ::  :::: :: ');
    Sys.println('   :   : :  : :: ::    : :  :   ::    :   :: : :  ');
    Sys.println('----------------------------------------------------');
    Sys.println('');
    Sys.println('Aeons version ${version}.');
  }

  /**
   * Create a new project.
   * @param path The folder to create it in.
   * @param name The name of the project.
   */
  static function createProject(path: String, name: String) {
    final destination = Path.join([path, name]);
    Sys.println('Creating new project at ${destination}');

    if (FileSystem.exists(destination)) {
      Sys.println('folder ${destination} already exists');
      return;
    }

    final aeonsPath = getHaxelibPath('aeons');
    final templatePath = Path.join([aeonsPath, 'tools/data/templates/starter']);

    FileSystem.createDirectory(destination);

    // Copy the template files.
    copyDir(templatePath, destination);

    // Create empty 'assets' folder.
    final assetsPath = Path.join([destination, 'assets']);
    FileSystem.createDirectory(assetsPath);

    // Create empty 'shaders' folder.
    final shadersPath = Path.join([destination, 'shaders']);
    FileSystem.createDirectory(shadersPath);

    // Create empty 'atlasImages' folder.
    final atlasPath = Path.join([destination, 'atlasImages']);
    FileSystem.createDirectory(atlasPath);

    // Update the project name place holders.
    Sys.println('Updating placeholders');
    final khafilePath = Path.join([destination, 'aeons.toml']);
    setPlaceholders(khafilePath, 'game_name', name);

    final mainPath = Path.join([destination, 'source/Main.hx']);
    setPlaceholders(mainPath, 'game_name', name);
    Sys.println('Project creation complete.');

    final config = readConfig(destination);
    writeKhafile(destination, config, '');
  }

  /**
   * Read a aeons.toml config file and return the config data.
   * @param projectDir The directory with the config file.
   * @return The loaded config file.
   */
  static function readConfig(projectDir: String): Config {
    Sys.setCwd(projectDir);
    final configPath = Path.join([projectDir, 'aeons.toml']);
    if (FileSystem.exists(configPath)) {
      final content = File.getContent(configPath);
      final config: Config = TomlParser.parseString(content, {});

      return config;
    } else {
      Sys.println('Missing aeons.toml config file');
      return null;
    }
  }

  /**
   * Create a khafile from an aeons config.
   * @param projectDir The directory the khafile should be saved in.
   * @param config The aeons config file.
   * @param exportPlatform
   * @return True if the creation was successful.
   */
  static function writeKhafile(projectDir: String, config: Config, exportPlatform: String): Bool {
    if (config.aeons == null) {
      Sys.println('Cannot find "[aeons]" project info in aeons.toml');
      return false;
    } else if (config.aeons.projectName == null) {
      Sys.println('"projectName" is missing from aeons.toml');
      return false;
    }

    Sys.println('Updating khafile.js');

    final aeons = config.aeons;
    final platform = Sys.systemName();
    final lineEnd = platform == "Windows" ? "\r\n" : "\n";

    final aeonsPath = getHaxelibPath('aeons');
    final templatePath = Path.join([aeonsPath, 'tools/data/khafile/khafileTemplate.js']);
    var template = File.getContent(templatePath);

    template = setPlaceholder(template, 'project_name', aeons.projectName);

    final assetsFolder = aeons.assetsFolder == null ? 'assets' : aeons.assetsFolder;
    template = setPlaceholder(template, 'assets', assetsFolder);

    final iconPath = aeons.icon == null ? 'icon.png' : aeons.icon;
    template = setPlaceholder(template, 'icon', iconPath);

    final shadersFolder = aeons.shaderFolder == null ? 'shaders' : aeons.shaderFolder;
    template = setPlaceholder(template, 'shaders', shadersFolder);

    final sourceFolder = aeons.sourceFolder == null ? 'source' : aeons.sourceFolder;
    template = setPlaceholder(template, 'source', sourceFolder);

    // Add haxe libraries.
    var libraries = '';
    if (aeons.libraries != null) {
      for (library in aeons.libraries) {
        libraries += 'project.addLibrary(\'${library}\');${lineEnd}';
      }
    }
    template = setPlaceholder(template, 'libraries', libraries);

    // Add haxe defines.
    var defines = '';
    if (aeons.defines != null) {
      for (define in aeons.defines) {
        defines += 'project.addDefine(\'${define}\');${lineEnd}';
      }
    }
    template = setPlaceholder(template, 'defines', defines);

    // Add haxe parameters.
    var parameters = '';
    if (aeons.parameters != null) {
      for (parameter in aeons.parameters) {
        parameters += 'project.addParameter(\'${parameter}\');${lineEnd}';
      }
    }
    template = setPlaceholder(template, 'parameters', parameters);

    var options = '';

    // Add html5 specific options.
    if (aeons.html5 != null) {
      options += addHtml5Options(aeons.html5, lineEnd, exportPlatform == 'html5', projectDir);
    }

    // Add android specific options.
    if (aeons.android != null) {
      options += addAndroidOptions(aeons.android, lineEnd);
    }

    // Add ios specific options.
    if (aeons.ios != null) {
      options += addIosOptions(aeons.ios, lineEnd);
    }

    template = setPlaceholder(template, 'options', options);

    final savePath = Path.join([projectDir, 'khafile.js']);
    File.saveContent(savePath, template);

    return true;
  }

  /**
   * Go through all html5 target specific options and add them to the khafile string.
   * @param config The html5 part of the config.
   * @param lineEnd Line ending is plafform specific.
   * @param customIndex Should the optional custom index file be exported.
   * @param proojectDir The project directory.
   * @return The html5 options as a string.
   */
  static function addHtml5Options(config: Html5, lineEnd: String, customIndex: Bool, projectDir: String): String {
    var options = '';
    final html5Options = 'project.targetOptions.html5.{{option}};${lineEnd}';
    final windowOptions = 'project.windowOptions.{{option}};${lineEnd}';

    if (config.disableContextMenu != null) {
      options += html5Options;
      options = setPlaceholder(options, 'option', 'disableContextMenu = ${config.disableContextMenu}');
    }

    if (config.canvasId != null) {
      options += html5Options;
      options = setPlaceholder(options, 'option', 'canvasId = \'${config.canvasId}\'');
    }

    if (config.scriptName != null) {
      options += html5Options;
      options = setPlaceholder(options, 'option', 'scriptName = \'${config.scriptName}\'');
    }

    if (config.width != null) {
      options += windowOptions;
      options = setPlaceholder(options, 'option', 'width = ${config.width}');
    }

    if (config.height != null) {
      options += windowOptions;
      options = setPlaceholder(options, 'option', 'height = ${config.height}');
    }

    if (config.customIndexFile != null && customIndex) {
      final indexPath = Path.join([projectDir, config.customIndexFile]);
      var buildDir = Path.join([projectDir, 'build']);
      if (!FileSystem.exists(buildDir)) {
        FileSystem.createDirectory(buildDir);
      }

      buildDir = Path.join([buildDir, 'html5']);
      if (!FileSystem.exists(buildDir)) {
        FileSystem.createDirectory(buildDir);
      }

      final destination = Path.join([buildDir, 'index.html']);
      File.copy(indexPath, destination);
    }

    return options;
  }

  /**
   * Go through all android target specific options and add them to the khafile string.
   * @param config The android part of the config.
   * @param lineEnd Line ending is plafform specific.
   * @return The android options as a string.
   */
  static function addAndroidOptions(config: Android, lineEnd: String): String {
    var options = '';
    final androidOptions = 'project.targetOptions.android_native.{{option}};${lineEnd}';

    if (config.packageName != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'package = \'${config.packageName}\'');
    }

    if (config.versionCode != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'versionCode = ${config.versionCode}');
    }

    if (config.versionName != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'versionName = \'${config.versionName}\'');
    }

    if (config.screenOrientation != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'screenOrientation = \'${config.screenOrientation}\'');
    }

    if (config.permissions != null) {
      var permissions = '';
      for (permission in config.permissions) {
        permissions += '\'${permission}\',';
      }
      if (permissions != '') {
        permissions = permissions.substring(0, permissions.length - 1);
      }
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'permissions = [${permissions}]');
    }

    if (config.installLocation != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'installLocation = \'${config.installLocation}\'');
    }

    if (config.metadata != null) {
      var metadata = '';
      for (data in config.metadata) {
        metadata += '\'${data}\',';
      }
      if (metadata != '') {
        metadata = metadata.substring(0, metadata.length - 1);
      }
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'metadata = [${metadata}]');
    }

    if (config.disableStickyImmersiveMode != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'disableStickyImmersiveMode = ${config.disableStickyImmersiveMode}');
    }

    if (config.globalBuildGradlePath != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'globalBuildGradlePath = \'${config.globalBuildGradlePath}\'');
    }

    if (config.buildGradlePath != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'buildGradlePath = \'${config.buildGradlePath}\'');
    }

    if (config.proguardRulesPath != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'proguardRulesPath = \'${config.proguardRulesPath}\'');
    }

    if (config.customFilesPath != null) {
      options += androidOptions;
      options = setPlaceholder(options, 'option', 'customFilesPath = \'${config.customFilesPath}\'');
    }

    return options;
  }

  /**
   * Go through all ios target specific options and add them to the khafile string.
   * @param config The ios part of the config.
   * @param lineEnd Line ending is plafform specific.
   * @return The ios options as a string.
   */
  static function addIosOptions(config: Ios, lineEnd: String): String {
    var options = '';
    final iosOptions = 'project.targetOptions.ios.{{option}};${lineEnd}';

    if (config.bundle != null) {
      options += iosOptions;
      options = setPlaceholder(options, 'option', 'bundle = \'${config.bundle}\'');
    }

    if (config.organizationName != null) {
      options += iosOptions;
      options = setPlaceholder(options, 'option', 'organizationName = \'${config.organizationName}\'');
    }

    if (config.developmentTeam != null) {
      options += iosOptions;
      options = setPlaceholder(options, 'option', 'developmentTeam = \'${config.developmentTeam}\'');
    }

    if (config.version != null) {
      options += iosOptions;
      options = setPlaceholder(options, 'option', 'version = \'${config.version}\'');
    }

    if (config.build != null) {
      options += iosOptions;
      options = setPlaceholder(options, 'option', 'build = \'${config.build}\'');
    }

    return options;
  }

  /**
   * Recursive copy a directory.
   * @param source The source folder.
   * @param destination The destination folder.
   */
  static function copyDir(source: String, destination: String) {
    final files = FileSystem.readDirectory(source);
    for (file in files) {
      final sourcePath = Path.join([source, file]);
      final destinationPath = Path.join([destination, file]);
      if (FileSystem.isDirectory(sourcePath)) {
        FileSystem.createDirectory(destinationPath);
        copyDir(sourcePath, destinationPath);
      } else {
        File.copy(sourcePath, destinationPath);
      }
    }
  }

  static function setPlaceholders(path: String, placeholder: String, replacement: String) {
    var content = File.getContent(path);
    content = setPlaceholder(content, placeholder, replacement);
    File.saveContent(path, content);
  }

  static function setPlaceholder(content: String, placeholder: String, replacement: String): String {
    return content.replace('{{${placeholder}}}', replacement);
  }

  static function showHelp() {
    Sys.println('');
    Sys.println('The following commands are available:');
    Sys.println('- aeons setup                  Download Kha and install the \'aeons\' command line command.');
    Sys.println('- aeons create [project_name]  Create a starter project in the current directory.');
    Sys.println('- aeons build [platform]       Build the project. See Kha for all supported platforms.');
    Sys.println('- aeons atlas                  Generate a sprite atlas in a folder with a atlas.json config file.');
    Sys.println('- aeons help                   Show this list');
    Sys.println('- aeons location [kha]         Shows the aeons path. If kha is added it shows the kha path.');
    Sys.println('- aeons update kha             Update the Kha framework to the commit tested with Aeons.');
    Sys.println('- aeons update latest-kha      Update the Kha framework to the latest version. This could break Aeons if there were Api changes in Kha.');
  }
}

typedef Config = {
  var aeons: Project;
  var ?atlas: Array<Dynamic>;
}

typedef Project = {
  var projectName: String;
  var ?assetsFolder: String;
  var ?shaderFolder: String;
  var ?sourceFolder: String;
  var ?icon: String;
  var ?libraries: Array<String>;
  var ?defines: Array<String>;
  var ?parameters: Array<String>;
  var ?html5: Html5;
  var ?android: Android;
  var ?ios: Ios;
}

typedef Html5 = {
  var ?disableContextMenu: Bool;
  var ?canvasId: String;
  var ?scriptName: String;
  var ?width: Int;
  var ?height: Int;
  var ?customIndexFile: String;
}

typedef Android = {
  var ?packageName: String;
  var ?versionCode: Int;
  var ?versionName: String;

  // https://developer.android.com/guide/topics/manifest/activity-element.html#screen
  var ?screenOrientation: String;
  var ?permissions: Array<String>;
  // https://developer.android.com/guide/topics/manifest/manifest-element#install
  var ?installLocation: String;
  // https://developer.android.com/guide/topics/manifest/meta-data-element
  var ?metadata: Array<String>;
  // same as <meta-data android:name="disableStickyImmersiveMode" android:value="true"/>
  var ?disableStickyImmersiveMode: Bool;
  var ?globalBuildGradlePath: String;
  var ?buildGradlePath: String;
  var ?proguardRulesPath: String;
  // for files in Android Studio project-level dir
  var ?customFilesPath: String;
}

typedef Ios = {
  var ?bundle: String;
  var ?organizationName: String;
  var ?developmentTeam: String;
  var ?version: String;
  var ?build: Int;
}
