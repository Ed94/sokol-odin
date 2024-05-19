$devshell = Join-Path $PSScriptRoot 'devshell.ps1'
& $devshell -arch amd64

$path_sokol = Join-Path $PSScriptRoot 'sokol'
if (test-path $path_sokol)
{
	Move-Item   -Path "$path_sokol/*" -Destination $PSScriptRoot -Force
	Remove-Item -Path $path_sokol -Recurse -Force
}

& '.\build_clibs_windows.cmd'
