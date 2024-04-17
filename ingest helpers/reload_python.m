function reload_python(modname)

%clear classes
mod = py.importlib.import_module(modname);
py.importlib.reload(mod)

end