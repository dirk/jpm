
load(strcat(JPM_PATH,"/lib/util/json.jl"))
load(strcat(JPM_PATH,"/lib/util/util.jl"))

# Core functionality to load packages
load(strcat(JPM_PATH,"/lib/core.jl"))

# It's being called from the command-line
function jpm_main()
  # Pull in the command files
  load(strcat(JPM_PATH,"/lib/help.jl"))
  load(strcat(JPM_PATH,"/lib/info.jl"))
  load(strcat(JPM_PATH,"/lib/install.jl"))
  
  if length(ARGS) > 0
    arguments = map(strip, ARGS)
    command = arguments[1]
    if command == "help" || command == "-h" || command == "--help"
      jpm_help()
    elseif command == "info"
      jpm_info(arguments[2])
    elseif command == "install"
      jpm_install_global(arguments[2])
    elseif command == "install-local"
      jpm_install_local(arguments[2])
    else
      puts("Unrecognized command: $command")
    end
  else
    jpm_help()
  end
end
