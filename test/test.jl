# Configure this after installing!
JPM_PATH = "/projects/julia/jpm"
JPM_PACKAGES = "/usr/local/julia_packages"
load(strcat(JPM_PATH,"/lib/jpm.jl"))

ex = load_package("jpm_example_package")

@assert ex["test"] == 2

# Uncommenting this should throw an error
#println(example_package)
