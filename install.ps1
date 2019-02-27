[CmdletBinding()]
Param(
	[String] $TexMFRoot = "~/texmf"
)

$class = "rebeccaessay"
$pkg = "rebeccastyle"
$dest = (Join-Path $TexMFRoot  "tex/latex/$class")
If(!(Test-Path $dest)) {
	mkdir $dest
}

cp "$class.cls" $dest
cp "$pkg.sty" $dest
pushd
cd ~
kpsewhich "$class.cls"
kpsewhich "$pkg.sty"
popd
