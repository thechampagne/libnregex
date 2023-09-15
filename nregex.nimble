# Package

version       = "0.1.1"
author        = "XXIV"
description   = "A C library for parsing, compiling, and executing regular expressions"
license       = "MIT"

# Dependencies

requires "nim >= 1.0.0"
requires "regex == 0.20.2"

task static, "Build a static library":
  exec "nim c --noMain --nimMainPrefix:nregex --app:staticlib -d:release --outdir:build nregex.nim"

task shared, "Build a shared library":
  exec "nim c --noMain --nimMainPrefix:nregex --app:lib -d:release --outdir:build nregex.nim"

task installdeps, "Install required dependencies":
  exec "nimble install regex@0.20.2"
