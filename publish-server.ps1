Push-Location "server"
Remove-Item -Path "bin" -Recurse
foreach ($os in "win", "linux", "osx") {
	dotnet publish --nologo --verbosity quiet --self-contained --framework net6.0 -p:PublishSingleFile=true -p:PublishTrimmed=true --runtime $os-x64 --output bin/tmp
	if ($os -eq "win") {
		Move-Item -Path "bin/tmp/Loretta.LanguageServer.exe" -Destination "bin/loretta-lsp-win.exe"
	}
	else {
		Move-Item -Path "bin/tmp/Loretta.LanguageServer" -Destination "bin/loretta-lsp-$os"
	}
	Remove-Item -Path "bin/tmp" -Recurse
}
Pop-Location
