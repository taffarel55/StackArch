from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).parent

VU = VUnit.from_argv(compile_builtins=False)
VU.add_verilog_builtins()

VU.add_library("ula_library").add_source_files(ROOT / "ula*.v")

VU.main()
