package;

import sys.io.Process;

using StringTools;

class RunScript {
  public static function main() {
    var args = Sys.args();
    var cachedDir = Sys.getCwd();
    var wd = args.pop();

    if (args.length == 1 && args[0] == 'help') {
      printLogo();
      Sys.println('Placeholder for help commands');
      Sys.exit(0);
    } else if (args.length > 1 && args[0] == 'create') {
      Sys.println("used create");
      Sys.println(args.length);
      Sys.exit(0);
    }

    // return;
    var path = getHaxelibPath('aeons');
    // trace(path);

    var cwd = Sys.getCwd();
    // trace('working dir ${cwd}');
    printLogo();

    Sys.exit(0);
    // Sys.exit(downloadKha());
  }

  public static function getHaxelibPath(name:String):String
	{
		final proc = new Process("haxelib", ["path", name]);
		var result = "";

		try
		{
			var previous = "";
			while (true)
			{
				final line:String = proc.stdout.readLine();
				if (line.startsWith('-D $name'))
				{
					result = previous;
					break;
				}
				previous = line;
			}
		}
		catch (e:Dynamic) {}
		proc.close();

		return result;
	}

	/**
	 * Shortcut to join paths that is platform safe
	 */
	public static function combine(firstPath:String, secondPath:String):String
	{
		if (firstPath == null || firstPath == "")
		{
			return secondPath;
		}
		else if (secondPath != null && secondPath != "")
		{
			if (Sys.systemName() == "Windows")
			{
				if (secondPath.indexOf(":") == 1)
				{
					return secondPath;
				}
			}
			else if (secondPath.substr(0, 1) == "/")
			{
				return secondPath;
			}

			final firstSlash:Bool = (firstPath.substr(-1) == "/" || firstPath.substr(-1) == "\\");
			final secondSlash:Bool = (secondPath.substr(0, 1) == "/" || secondPath.substr(0, 1) == "\\");

			if (firstSlash && secondSlash)
			{
				return firstPath + secondPath.substr(1);
			}
			else if (!firstSlash && !secondSlash)
			{
				return firstPath + "/" + secondPath;
			}
			else
			{
				return firstPath + secondPath;
			}
		}

		return firstPath;
	}

  private static function runCommand(path: String, command: String, args: Array<String>, throwErrors = true): Int {
    var oldPath = '';
    if (path != null && path != '') {
      oldPath = Sys.getCwd();

      try {
        Sys.setCwd(path);
      } catch (e: Dynamic) {
        trace('cannot set current working directory to %{path}.');
      }
    }

    var result = Sys.command(command, args);
    trace('result ${result}');
    if (oldPath != '') {
      Sys.setCwd(oldPath);
    }

    if (result != 0 && throwErrors) {
      Sys.exit(1);
    }

    return result;
  }

  private static function downloadKha() {
    
    return runCommand('lib', 'git', ['clone', 'https://github.com/codescapade/KhaBundled']);
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
}