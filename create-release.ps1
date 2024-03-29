Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$paths = @(
	"client/out",
	"client/package.json",
	"server/bin",
	"syntaxes",
	".vscodeignore",
	"language-configuration.json",
	"package.json",
	"README.md",
	"LICENSE.md"
);
$package = Get-Content "package.json" | ConvertFrom-Json
$version = $package.version
$distDir = "dist"
$distVersionDir = "$distDir/$version"
$vsixName = "vscode-loretta-$version.vsix"

Write-Output "Version: $version"
Write-Output "::set-output name=VERSION::$version"

yarn run compile

Remove-Item $distDir -Recurse -ErrorAction SilentlyContinue
New-Item $distVersionDir -ItemType Directory
foreach ($path in $paths) {
	Copy-Item $path -Destination "$distVersionDir/$path" -Recurse
}

Push-Location $distVersionDir
npx vsce package -o "../$vsixName"
Pop-Location

Remove-Item $distVersionDir -Recurse -ErrorAction Continue
