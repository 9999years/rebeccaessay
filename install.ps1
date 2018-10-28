[CmdletBinding()]
Param(
	[String] $TexMFRoot = "~/texmf"
)

$class = "rebeccaessay"
$dest = (Join-Path $TexMFRoot  "tex/latex/$class")
If(!(Test-Path $dest)) {
	mkdir $dest
}

cp "$class.cls" $dest
pushd
cd ~
kpsewhich "$class.cls"
popd
