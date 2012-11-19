# Going to be naughty and override puts.
puts = println

function jpm_read_file(f)
  stream = open(f, "r")
  return readall(stream)
end

function jpm_get_package_json(fname)
  contents = jpm_read_file(fname)
  return parse_json(contents)
end

function jpm_get_global_package_path(package_name)
  strcat(JPM_PACKAGES,"/$package_name")
end
function jpm_get_global_package_json(package_name)
  jpm_get_package_json(strcat(jpm_get_global_package_path(package_name),"/package.json"))
end

function jpm_get_local_package_path(package_name)
  strcat(cwd(),"/julia_packages/$package_name")
end
function jpm_get_local_package_json(package_name)
  jpm_get_package_json(strcat(jpm_get_local_package_path(package_name),"/package.json"))
end

function jpm_get_registry_package_file(package_name)
  strcat(JPM_PATH,"/registry/$package_name/package.json")
end

function jpm_get_registry_package_json(package_name)
  jpm_get_package_json(jpm_get_registry_package_file(package_name))
end

function starts_with(haystack, needle)
  if length(haystack) < length(needle)
    return false
  end
  return haystack[1:length(needle)] == needle
end
