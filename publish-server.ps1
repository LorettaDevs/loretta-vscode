param(
	[switch]$Debug = $false
)

$package = Get-Content "package.json" | ConvertFrom-Json
$version = $package.version

$archs = @("win", "linux", "osx")
$dotnetArgs = @(
	"--nologo",
	"--verbosity", "quiet",
	"--self-contained",
	"--framework", "net6.0",
	"-p:PublishSingleFile=true",
	"-p:Version=$version"
)
if ($Debug) {
	$dotnetArgs += @("--configuration", "Debug")
}
else {
	$dotnetArgs += @(
		"--configuration", "Release",
		"-p:PublishTrimmed=true"
	)
}

Push-Location "server"
foreach ($os in $archs) {
	if ($os -eq "win") {
		Remove-Item -Path "bin/loretta-lsp-win.exe" -ErrorAction SilentlyContinue
	}
	else {
		Remove-Item -Path "bin/loretta-lsp-$os" -ErrorAction SilentlyContinue
	}
	dotnet publish @dotnetArgs --runtime "$os-x64" --output "bin/$os"
	if ($os -eq "win") {
		Copy-Item -Path "bin/$os/Loretta.LanguageServer.exe" -Destination "bin/loretta-lsp-win.exe"
	}
	else {
		Copy-Item -Path "bin/$os/Loretta.LanguageServer" -Destination "bin/loretta-lsp-$os"
	}
	Remove-Item -Path "bin/$os" -Recurse
}
Pop-Location
