package;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;

class RunScript {

  public static function main() {
    final args = Sys.args();
    final wd = args.pop();

    // aeons help
    if (args.length == 1 && args[0] == 'help' || args[0] == 'h') {
      printLogo();
      showHelp();
      Sys.exit(0);
    // aeons setup
    } else if (args.length == 1 && args[0] == 'setup') {
      setupAeons();
      Sys.exit(0);
    // aeons create [project_name]
    } else if (args.length > 1 && args[0] == 'create') {
      createProject(wd, args[1]);
      Sys.exit(0);
    }

    printLogo();
    Sys.exit(0);
  }

  /**
   * Find the location of a haxelib library.
   * @param name The library to find.
   * @return The location path.
   */
  private static function getHaxelibPath(name: String): String {
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

  /**
   * Run a Sys command and restore the working directory after.
   * @param path The path to run the command in.
   * @param command The command to run.
   * @param args A list of command parameters.
   * @param throwErrors Show this throw errors.
   * @return The command status. 0 is success.
   */
  private static function runCommand(path: String, command: String, args: Array<String>, throwErrors = true): Int {
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

  private static function setupAeons() {
    downloadKha();
    setupAlias();
  }

  /**
   * Copy aeons.bat or aeons.sh to the haxe folder so you can run the aeons command.
   */
  private static function setupAlias() {
    final platform = Sys.systemName();
    final binPath = if (platform == 'Mac') "/usr/local/bin" else "/usr/bin";

    if (platform == 'Windows') {
      var haxePath: String = Sys.getEnv('HAXEPATH');
      if (haxePath == null || haxePath == '')
        haxePath = 'C:\\HaxeToolkit\\haxe\\';

      final destination = Path.join([haxePath ,'aeons.bat']);
      final source = Path.join([getHaxelibPath('aeons'), 'data/bin/aeons.bat']);

      if (FileSystem.exists(source)) {
        File.copy(source, destination);
      } else {
        throw 'Could not find the aeons alias script.';
      }
    } else {
      final source = Path.join([getHaxelibPath('aeons'), 'data/bin/aeons.sh']);

      if (FileSystem.exists(source)) {
        Sys.command("sudo", ["cp", source, binPath + "/flixel"]);
        Sys.command("sudo", ["chmod", "+x", binPath + "/flixel"]);
      }
      else {
        throw 'Could not find the aeons alias script.';
      }
    }
  }

  /**
   * Download Kha. Overwrite the existing installation if it exists.
   */
  private static function downloadKha() {
    Sys.println('Downloading Kha to aeons/lib/KhaBundled');
    final libPath = Path.join([getHaxelibPath('aeons'), 'lib']);
    if (!FileSystem.exists(libPath)) {
      FileSystem.createDirectory(libPath);
    }

    final path = Path.join([libPath, 'lib/KhaBundled']);
    if (FileSystem.exists(path)) {
      deleteDir(path);
    }

    Sys.setCwd(libPath);

    return runCommand('', 'git', ['clone', 'https://github.com/codescapade/KhaBundled']);
    Sys.println('Download of Kha completed');
  }

  private static function printLogo() {
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
    Sys.println('Aeons command line tools version 0.1.0.');
    Sys.println('Use \'aeons help\' for a list of commands.');
  }

  /**
   * Create a new project.
   * @param path The folder to create it in.
   * @param name The name of the project.
   */
  private static function createProject(path: String, name: String) {
    final destination = Path.join([path, name]);
    Sys.println('Creating new project at ${destination}');

    if (FileSystem.exists(destination)) {
      Sys.println('folder ${destination} already exists');
      return;
    }

    final aeonsPath = getHaxelibPath('aeons');
    final templatePath = Path.join([aeonsPath, 'data/templates/starter']);

    FileSystem.createDirectory(destination);

    // Copy the template files.
    copyDir(templatePath, destination);

    // Create empty 'assets' folder.
    final assetsPath = Path.join([destination, 'assets']);
    FileSystem.createDirectory(assetsPath);

    // Create empty 'shaders' folder.
    final shadersPath = Path.join([destination, 'shaders']);
    FileSystem.createDirectory(shadersPath);

    // Update the project name place holders.
    Sys.println('Updating placeholders');
    final khafilePath = Path.join([destination, 'khafile.js']);
    setPlaceholders(khafilePath, '{{game_name}}', name);

    final mainPath = Path.join([destination, 'source/Main.hx']);
    setPlaceholders(mainPath, '{{game_name}}', name);

    // Set the kha path for vscode to the downloaded kha install.
    final settingsPath = Path.join([destination, '.vscode/settings.json']);
    final khaPath = Path.join([aeonsPath, 'lib/KhaBundled']);
    setPlaceholders(settingsPath, '{{kha_path}}', khaPath);
    Sys.println('Project creation complete.');
  }

  /**
   * Recursive copy a directory.
   * @param source The source folder.
   * @param destination The destination folder.
   */
  private static function copyDir(source: String, destination: String) {
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
  private static function deleteDir(dir: String) {
    final files = FileSystem.readDirectory(dir);
    for (file in files) {
      final path = Path.join([dir, file]);
      if (FileSystem.isDirectory(path)) {
        deleteDir(path);
        FileSystem.deleteDirectory(path);
      } else {
        FileSystem.deleteFile(path);
      }
    }
  }

  private static function setPlaceholders(path: String, placeholder: String, name: String) {
    var content = File.getContent(path);
    content = content.replace(placeholder, name);
    File.saveContent(path, content);
  }

  private static function showHelp() {
    Sys.println('');
    Sys.println('The following commands are available:');
    Sys.println('- aeons create [project_name]  Create a starter project in the current directory.');
    Sys.println('- aeons setup                  Download Kha and install the aeons command line command.');
    Sys.println('- aeons help                   Show this list');
  }
}