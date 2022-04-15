package;

import haxe.Exception;
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;

class RunScript {

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
      setupAeons();
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
      if (args.indexOf('--no-atlas') == -1) {
        args.remove('--no-atlas');
        generateAtlas(wd);
      }
      Sys.exit(build(wd, args));
    // aeons location [kha]
    } else if (args.length >= 1 && args[0] == 'location') {
      final haxelibPath = getHaxelibPath('aeons');
      if (args.length > 1 && args[1] == 'kha') {
        final khaPath = Path.join([haxelibPath, 'lib/Kha']);
        Sys.println('kha path: ${khaPath}');
      } else {
        Sys.println('aeons path: ${haxelibPath}');
      }
      Sys.exit(0);
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
				if (line.startsWith('-D $name'))
				{
					result = previous;
					break;
				}
				previous = line;
			}
		} catch (e: Dynamic) {

    }

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
      } catch (e: Dynamic) {
        trace('cannot set current working directory to %{path}.');
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

  static function setupAeons() {
    downloadKha();
    setupAlias();
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

      final destination = Path.join([haxePath ,'aeons.bat']);
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
      }
      else {
        throw 'Could not find the aeons alias script.';
      }
    }
    Sys.println('The "aeons" command has been added to path.');
  }

  /**
   * Download Kha. Overwrite the existing installation if it exists.
   */
  static function downloadKha() {
    final libPath = Path.join([getHaxelibPath('aeons'), 'lib']);
    final path = Path.join([libPath, 'Kha']);

    if (FileSystem.exists(path)) {
      Sys.println('${path} already exists. Skipping Kha download.');
      return;
    }

    Sys.println('Downloading Kha to aeons/lib/Kha');
    if (!FileSystem.exists(libPath)) {
      FileSystem.createDirectory(libPath);
    }

    Sys.setCwd(libPath);

    runCommand('', 'git', ['clone', 'https://github.com/codescapade/Kha']);
    runCommand('Kha', 'git', ['checkout', '9d9bb55']);
    runCommand('Kha', 'git', ['submodule', 'update', '--init', '--recursive']);

    Sys.println('Download of Kha completed');
  }

  /**
   * Aeons build command that uses Kha to build the project.
   * @param projectDir The project directory. 
   * @param args Arguments for khamake. Must have at least the platform.
   */
  static function build(projectDir: String, args: Array<String>) {
    Sys.setCwd(projectDir);

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
      appPath = Path.join([haxelibPath, 'tools/atlas/AeonsAtlas.exe']);
    } else if (platform == 'Mac') {
      appPath = Path.join([haxelibPath, 'tools/atlas/AeonsAtlasMac']);
    } else if (platform == 'Linux') {
      appPath = Path.join([haxelibPath, 'tools/atlas/AeonsAtlasLinux']);
    }

    if (appPath == '') {
      Sys.println('Aeons Atlas executable not found. Skipping atlas generation.');
    } else {
      if (FileSystem.exists('atlas.json')) {
        runCommand('', appPath, []);
      } else {
        Sys.println('No atlas.json file found. Skipping atlas generation.');
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
    final khafilePath = Path.join([destination, 'khafile.js']);
    setPlaceholders(khafilePath, '{{game_name}}', name);

    final mainPath = Path.join([destination, 'source/Main.hx']);
    setPlaceholders(mainPath, '{{game_name}}', name);

    // Set the kha path for vscode to the downloaded kha install.
    final settingsPath = Path.join([destination, '.vscode/settings.json']);
    final khaPath = Path.join([aeonsPath, 'lib/Kha']);
    setPlaceholders(settingsPath, '{{kha_path}}', khaPath);
    Sys.println('Project creation complete.');
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

  /**
   * Delete a folder recursive.
   * @param dir The folder to delete.
   */
  static function deleteDir(dir: String) {
    final files = FileSystem.readDirectory(dir);
    for (file in files) {
      final path = Path.join([dir, file]);
      trace(path);
      if (FileSystem.isDirectory(path)) {
        deleteDir(path);
        var newFiles = FileSystem.readDirectory(path);
        if (newFiles.length == 0) {
          FileSystem.deleteDirectory(path);
        }
      } else {
        if (FileSystem.exists(path)) {
          try {
            FileSystem.deleteFile(path);
          } catch (e: Exception) {
            trace(e.toString());
          }
        }
      }
    }
  }

  static function setPlaceholders(path: String, placeholder: String, name: String) {
    var content = File.getContent(path);
    content = content.replace(placeholder, name);
    File.saveContent(path, content);
  }

  static function showHelp() {
    Sys.println('');
    Sys.println('The following commands are available:');
    Sys.println('- aeons setup                  Download Kha and install the aeons command line command.');
    Sys.println('- aeons create [project_name]  Create a starter project in the current directory.');
    Sys.println('- aeons build [platform]       Build the project. See Kha for all supported platforms.');
    Sys.println('- aeons atlas                  Generate a sprite atlas in a folder with a atlas.json config file.');
    Sys.println('- aeons help                   Show this list');
    Sys.println('- aeons location [kha]         Shows the aeons path. If kha is added it shows the kha path.');
  }
}
