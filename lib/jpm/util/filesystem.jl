
if !isdefined(:dir_exists)
  function dir_exists(path)
    system("[ -d $path ]") == 0
  end
end

if !isdefined(:file_exists)
  function file_exists(path)
    system("[ -f $path ]") == 0
  end
end

function jpm_path_exists(path)
  system("[ -e $path ]") == 0
end

if !isdefined(:path_exists)
  path_exists = jpm_path_exists
  #function exists(path)
  #  system("[ -e $path ]") == 0
  #end
end
