function jpm_info(package_name)
  # Adapted from: https://github.com/visionmedia/mocha/blob/master/lib/reporters/base.js
  test_colors = {
    "grey" => 90,
    "green" => 32,
    "bold" => 1,
    # "fail" => 31
    # "bright pass" => 92
    # "bright fail" => 91
    # "bright yellow" => 93
    # "pending" => 36
    # "suite" => 0
    # "error title" => 0
    # "error message" => 31
    # "error stack" => 90
    # "fast" => 90
    # "medium" => 33
    # "slow" => 31
    # "green" => 32
    # "light" => 90
    # "diff gutter" => 90
    # "diff added" => 42
    # "diff removed" => 41
  }
  color(s, c) = strcat("\033[", test_colors[c], "m", s, "\033[0m")
  
  
  #dict = parse_json()
  #stream = open(, "r")
  #contents = readall(stream)
  #fname = strcat(JPM_PATH,"/registry/$package/package.json")
  #contents = jpm_read
  #println(contents)
  package = jpm_get_package_json(package_name)
  #show(package)
  #println()
  println(color("package: ", "grey"), package_name)
  println(color("  name: ", "grey"), package["name"])
  if has(package, "description")
    println(color("  description: ", "grey"), package["description"])
  end
  if has(package, "repository")
    println(color("  repository:", "grey"))
    println(color(strcat("    ",package["repository"]["type"],": "), "grey"), package["repository"]["url"])
  end
  if has(package, "version")
    println(color("  version: ", "grey"), package["version"])
  end
  if has(package, "bin")
    #println(color("  bin: ", "grey"), package["bin"])
    println(color("  bin:", "grey"))
    bins = package["bin"]
    for k in keys(bins)
      println("    ",k,color(" -> ", "grey"),bins[k])
    end
  end
  
  println()
end
