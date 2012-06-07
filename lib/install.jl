function jpm_install(package_name, dest)
  current_dir = cwd()
  
  package = jpm_get_package_json(package_name)
  if !has(package, "repository")
    println("Package definition does not provide a repository")
    return
  end
  p_type = package["repository"]["type"]
  if p_type != "git"
    println("Package repository type '$p_type' is not usable")
    return
  end
  
  p_url = package["repository"]["url"]
  
  # Returns 0 if destination already exists
  if system("[ -e $dest ]") == 0
    print("The package $package_name already exists at '$dest'. Overwrite? (y/n) ")
    flush(stdout_stream) # Make sure the print gets shown before asking for input
    ans = lowercase(strip(readline(stdin_stream)))
    if !(ans == "y" || ans == "yes")
      println("Cancelled")
      return
    else
      run(`rm -rf $dest`)
    end
  end
  
  run(`git clone $p_url $dest`)
  
  println("\nPackage $package_name installed successfully.")
end

function jpm_install_global(package_name)
  jpm_install(package_name, strcat(JPM_PACKAGES,"/",package_name))
end
function jpm_install_local(package_name)
  packages_dir = strcat(cwd(),"/julia_packages")
  run(`mkdir -p $packages_dir`)
  jpm_install(package_name, strcat(packages_dir,"/",package_name))
end
