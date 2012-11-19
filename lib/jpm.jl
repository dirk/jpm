
module JPM

import JPMConfig
JPM_PATH = JPMConfig.path
JPM_PACKAGES = JPMConfig.packages

export main
using Base

load(strcat(JPM_PATH, "/lib/jpm/util/string.jl"))
#load(JPM_PATH + "/lib/jpm/util/json.jl")
require("extras/json.jl")
load(JPM_PATH + "/lib/jpm/util/util.jl")
load(JPM_PATH + "/lib/jpm/util/filesystem.jl")

# Core functionality to load packages
load(JPM_PATH + "/lib/jpm/core.jl")

# Pull in the command files
load(JPM_PATH + "/lib/jpm/commands/help.jl")
load(JPM_PATH + "/lib/jpm/commands/info.jl")
load(JPM_PATH + "/lib/jpm/commands/install.jl")

# It's being called from the command-line
function main()
  if length(ARGS) > 0
    arguments = map(strip, ARGS)
    command = arguments[1]
    if command == "help" || command == "-h" || command == "--help"
      if length(ARGS) >= 2
        jpm_help(string(ARGS[2])) # Help with a topic
      else
        jpm_help() # Generic help
      end
    elseif command == "info"
      if length(arguments) != 2
        puts("Package name required")
      else
        jpm_info(arguments[2])
      end
    elseif command == "install"
      if length(ARGS) >= 2
        jpm_install_global(arguments[2])
      else
        jpm_install_dependencies()
      end
    elseif command == "search"
      jpm_search(arguments[2])
    elseif command == "install-local"
      jpm_install_local(arguments[2])
    else
      puts("Unrecognized command: $command")
    end
  else
    jpm_help()
  end
end

end
