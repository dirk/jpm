
load(JPM_PATH + "/lib/jpm/package.jl")

function load_package(package_name)
  package = jpm_get_registry_package_json(package_name)
  current_dir = cwd()
  local_package_dir = strcat(current_dir,"/julia_packages/",package_name)
  global_package_dir = strcat(JPM_PACKAGES,"/",package_name)
  if system("[ -d $local_package_dir ]") == 0
    package_dir = local_package_dir
  elseif system("[ -d $global_package_dir ]") == 0
    package_dir = global_package_dir
  else
    error("Package $package_name not found")
    return
  end
  
  _exports = Dict()
  function _exporter(e)
    _exports = e
  end
  global exports
  exports = _exporter
  
  function _parse_file_into_exprs(fname)
    contents = jpm_read_file(fname)
    exprs = {}
    try
      pos = 0
      while true
        expr, newpos = parse(contents, pos)
        push(exprs, expr)
        pos = newpos
      end
    catch e
      if !(typeof(e) == ParseError && e.msg == "end of input")
        throw(e)
      end
    end
    
    # Find top-level calls to load_lib and replace them with the parsed
    # equivalent of that file
    adjusted_exprs = {}
    for expr in exprs
      if typeof(expr) == Expr
        if expr.head == :call && expr.args[1] == :load_lib
          push(
            adjusted_exprs,
            Expr(:block, _parse_file_into_exprs(strcat(package_dir,"/lib/",expr.args[2])), Any)
          )
        else
          push(adjusted_exprs, expr)
        end
      else
        push(adjusted_exprs, expr)
      end
    end
    
    return adjusted_exprs
  end
  
  function _parse_file_into_exprs_and_execute(fname)
    _exprs = _parse_file_into_exprs(fname)
    
    # Creating an anonymous function to contain the scope
    # See: https://groups.google.com/d/topic/julia-dev/iqaP3hXmNMM/discussion
    _anon_func_expr = Expr(:function, {
      Expr(:call, {symbol("_package")}, Any),
      Expr(:block, _exprs, Any)
    }, Any)
    
    eval(_anon_func_expr)
    _package()
  end
  
  fname = strcat(package_dir,"/lib/",package_name,".jl")
  if has(package, "enclose") && package["enclose"] == false
    load(fname)
  else
    _parse_file_into_exprs_and_execute(fname)
  end
  
  exports = nothing
  
  return _exports
end
