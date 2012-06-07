function jpm_info(package_name)
  #dict = parse_json()
  #stream = open(, "r")
  #contents = readall(stream)
  #fname = strcat(JPM_PATH,"/registry/$package/package.json")
  #contents = jpm_read
  #println(contents)
  package = jpm_get_package_json(package_name)
  show(package)
  println()
end
