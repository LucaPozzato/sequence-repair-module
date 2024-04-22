from pathlib import Path
from vunit import VUnit

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv(compile_builtins=False)

# Optionally add VUnit's builtin HDL utilities for checking, logging, communication...
vu.add_vhdl_builtins()

# Set the root to the directory of this script file
ROOT = Path(__file__).resolve().parent

# Create library 'lib' 
lib = vu.add_library("lib")
tb_lib = vu.add_library("tb_lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files(ROOT / "src" / "*.vhd")
tb_lib.add_source_files(ROOT / "test" / "vhd" / "*.vhd")

# Run vunit function
vu.main()

