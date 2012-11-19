
function jpm_info_from_package_json(package, package_name)
  # Adapted from: https://github.com/visionmedia/mocha/blob/master/lib/reporters/base.js
  test_colors = {
    "grey" => 90,
    "green" => 32,
    "bold" => 1
  }
  color(s, c) = strcat("\033[", test_colors[c], "m", s, "\033[0m")
  
  
  #dict = parse_json()
  #stream = open(, "r")
  #contents = readall(stream)
  #fname = strcat(JPM_PATH,"/registry/$package/package.json")
  #contents = jpm_read
  #println(contents)
  
  #show(package)
  #println()
  println(color("package: ", "grey"), package_name)
  #println(color("  name: ", "grey"), package["name"])
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
  if has(package, "installed_versions")
    println(color("  installed versions: ", "grey"), join(package["installed_versions"], ", "))
  end
  if has(package, "bin")
    #println(color("  bin: ", "grey"), package["bin"])
    println(color("  bin:", "grey"))
    bins = package["bin"]
    for k in keys(bins)
      println("    ",k,color(" -> ", "grey"),bins[k])
    end
  end
end

function jpm_info(package_name)
  # Adapted from: https://github.com/visionmedia/mocha/blob/master/lib/reporters/base.js
  test_colors = {
    "grey" => 90,
    "green" => 32,
    "bold" => 1
  }
  color(s, c) = strcat("\033[", test_colors[c], "m", s, "\033[0m")
  
  json = false
  source = ""
  
  # TODO: Add functionality for global packages (stored as "name-1.2.3", as
  #       compared to local stored as just "name")
  #
  #function _global()
  #  path = jpm_get_global_package_path(package_name)
  #  println(color("source: ", "grey"), "global packages")
  #  println(color("  definition: ", "grey"), strcat(path,"/package.json"),"\n")
  #  return jpm_get_global_package_json(package_name)
  #end
  function _global(packages)
    println(color("source: ", "grey"), "global repository")
    println(color("  definition: ", "grey"), packages[1].definition)
    
    #println(color("installed versions: ", "grey"), join(map(p -> string(p.version), packages)))
    attrs = copy(packages[1].attributes)
    attrs["installed_versions"] = reverse(map(p -> string(p.version), packages))
    return attrs
  end
  function _local()
    path = jpm_get_local_package_path(package_name)
    println(color("source: ", "grey"), "local repository")
    println(color("  definition: ", "grey"), strcat(path,"/package.json"))
    return jpm_get_local_package_json(package_name)
  end
  function _registry()
    println(color("source: ", "grey"), "local registry")
    println(color("  definition: ", "grey"), jpm_get_registry_package_file(package_name))
    return jpm_get_registry_package_json(package_name)
  end
  
  
  
  #if dir_exists(jpm_get_global_package_path(package_name))
  #  json = _global()
  #  source = "global packages"
  #elseif dir_exists(jpm_get_local_package_path(package_name))
  global_packages = jpm_get_global_versions(package_name)
  
  if dir_exists(jpm_get_local_package_path(package_name))
    json = _local()
    source = "local packages"
  elseif length(global_packages) > 0
    json = _global(global_packages)
    source = "global repository"
  elseif file_exists(jpm_get_registry_package_file(package_name))
    json = _registry()
    source = "local registry"
  else
    json = false
    source = "local registry"
  end
  
  if json != false
    jpm_info_from_package_json(json, package_name)
  else
    puts("Package '$package_name' not found in $source.")
  end
  println()
  
  if length(global_packages) > 0 && source != "global repository"
    println(color("other source: ", "grey"), "global repository")
    for p in global_packages
      println(color("  package: ", "grey"), p.name,"-",p.version)
    end
    println()
  end
  
end
