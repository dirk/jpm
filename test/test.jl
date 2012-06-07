# Configure this after installing!
JPM_PATH = "/projects/julia/jpm"
JPM_PACKAGES = "/usr/local/julia_packages"
load(strcat(JPM_PATH,"/lib/jpm.jl"))

ex = load_package("example_package")

@assert ex["test"] == 2

# Uncommenting this should throw an error
#println(example_package)

load_package("module")

@module_begin Test

@module_add Test function func(n)
  return n
end
@module_add Test val = 1

@module_end Test

@assert Test.val == 1
@assert Test.func(1) == 1
