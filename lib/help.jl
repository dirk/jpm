
jpm_help_topics = {"installing (install)", "information (info)"}

function jpm_help(topic::String)
  if topic == "installing" || topic == "install"
    puts(
      join(
        [
          "There are two ways to install a package, with `install` and",
          "`install-local`. The first will insall the named package globally",
          "in the JPM_PACKAGES directory, the second will install the package",
          "in the julia_packages/ folder in the current local working",
          "directory. You can also call `install` without any arguments to",
          "have jpm find any dependencies listed in the package.json file in",
          "the current working directory and install them into julia_packages/.",
          "\n"
        ],
        "\n"
      )#join
    )#puts
  elseif topic == "information" || topic == "info"
    puts(
      join(
        [
          "Call `jpm info <package name>` to find out more information about a",
          "package (including where it is located if it's installed).",
          "\n"
        ],
        "\n"
      )#join
    )#puts
  else
    if topic != "topics"
      puts("Help topic '$topic' not found.\n")
    end
    print("Available topics are:\n\t")
      puts(join(jpm_help_topics, ", "))
      puts()
  end
end

function jpm_help()
  puts(
    join(
      [
        "Usage: jpm <command>",
        "",
        "Where <command> is one of:",
        "\thelp, install, install-local, info\n",
        "You can also call `jpm help topics` for more in depth guides.",
        ""
      ],
      "\n"
    )#join
  )#println
end
