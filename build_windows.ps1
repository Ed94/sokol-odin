$devshell = Join-Path $PSScriptRoot 'devshell.ps1'

& $devshell -arch amd64

push-location '.\sokol'

& '.\build_clibs_windows.cmd'

pop-location
