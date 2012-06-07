# Going to be naughty and override puts.
puts = println

function jpm_read_file(f)
  stream = open(f, "r")
  return readall(stream)
end

function jpm_get_package_json(package_name)
  fname = strcat(JPM_PATH,"/registry/$package_name/package.json")
  contents = jpm_read_file(fname)
  return parse_json(contents)
end
