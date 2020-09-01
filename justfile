tar:
	nix-build -A tar -o rebeccaessay.tar.gz

dir:
	nix-build -A dir -o rebeccaessay

dir-pdf:
	nix-build -A dir-pdf -o rebeccaessay-pdf
