type jpm_Package
  name::String
  version::VersionNumber
  # Location of the definition file
  definition::String
  # The parsed JSON file
  attributes::Dict
  # Location of the repository directory
  repository::String
  # Whether or not this package is merely the definition file in the registry.
  in_registry::Bool
  # Which mode the package is being stored in (local or global)
  mode::Symbol
end

#VersionNumber(s::String) = convert(VersionNumber, s)

jpm_Package(n, v, d, a, r, in_r, m) = jpm_Package(n, VersionNumber(v), d, a, r, in_r, m)
jpm_Package(n, v, d, a, r) = jpm_Package(n, v, d, a, r, false, :global)
jpm_Package() = jpm_Package("", "1.0.0", "", {}, "", false, :global)

function jpm_find_package(package_name)
  
end

# Return an array of all packages (eg. {"one-1.0.0","two-2.0.0"}) in the
# global repository.
function jpm_get_global_listing()
  list = readall(`find $JPM_PACKAGES -type d -maxdepth 2` | `xargs basename`)
  # Split the list of files, strip off any whitespace, and slice off the
  # first item (which is the original directory).
  items = map(strip, split(strip(list), r"[\r\n]+"))[2:]
  return items
end

# Get all versions of a package (by name) in the global repository.
function jpm_get_global_versions(package_name)
  # Do a preliminary filter of the list to find directories starting
  # with the string "package_name-". This isn't perfect, but it's a start.
  items = filter(n -> starts_with(n, strcat(package_name,"-")), jpm_get_global_listing())
  
  function definition_file(name)
    JPM_PACKAGES + "/" + name + "/package.json"
  end
  
  # Read and parse the JSON files for each package
  packages_jsons = map(n -> jpm_get_package_json(definition_file(n)), items)
  
  packages = {}
  for p in packages_jsons
    if p["name"] == package_name
      push(packages,
        jpm_Package(
          p["name"],
          p["version"],
          definition_file(p["name"]),
          p, # Attributes
          JPM_PACKAGES, # Repository
          false, # Not in a registry
          :global # Global storage mode
        )
      )
    end
  end
  
  sort((a, b) -> isless(b.version, a.version), packages)
end
