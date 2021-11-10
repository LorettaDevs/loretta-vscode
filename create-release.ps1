$paths = @(
	"client/node_modules",
	"client/out",
	"client/package-lock.json",
	"client/package.json",
	"client/tsconfig.json",
	"server/bin",
	"syntaxes",
	".vscodeignore",
	"language-configuration.json",
	"package-lock.json",
	"package.json",
	"README.md",
	"LICENSE.md",
	"tsconfig.json"
);
$package = Get-Content "package.json" | ConvertFrom-Json
$version = $package.version
$distDir = "dist"
$distVersionDir = "$distDir/$version"
$vsixName = "vscode-loretta-$version.vsix"

npm run compile
Remove-Item $distDir -Recurse
New-Item $distVersionDir -ItemType Directory
foreach ($path in $paths) {
	Copy-Item -Path $path -Destination "$distVersionDir/$path" -Recurse
}
Push-Location $distVersionDir
npx vsce package -o "../$vsixName"
Pop-Location
Remove-Item -Path $distVersionDir -Recurse
