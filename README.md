# README #

These are my personal dotfile(s) and some (more or less) useful scripts I wrote. My bash .profile is optimized towards Mac OS X, but many of the aliases and functions work on Linux as well (with additional dependencies installed using a package installer of your choosing).

### What is this repository for? ###

* just messin' around with dotfiles
* easy command-line-based encryption and decryption of files and directories
* OCR your PDFs with _tesseract_ and output either searchable PDFs (pdftopdf) or plain text (pdftotxt)
* more coming...

### How do I get set up? ###

* _homebrew_ or _MacPorts_ on Mac, or the package installer of your Linux distro
* The encrypt and decrypt functions are basically wrapper around _openssl_, so they should be useable out-of-the-box on your machines!
* For the OCR functions, you need _tesseract_ (https://github.com/tesseract-ocr/tesseract), _pdftk_ (https://www.pdflabs.com/tools/pdftk-server/), and _ImageMagick_ (http://www.imagemagick.org/script/index.php) with all their dependencies. I do not use any custom-trained models for _tesseract_, so it's suited for any language you like (with all the potential limitations of the default models, however). _pdftk_ had some issues on El Capitan, but fortunately there is a(n inofficial?) recompiled installer that works on El Capitan (see http://stackoverflow.com/questions/32505951/pdftk-server-on-os-x-10-11).
(NOTE that OCR'ing isn't the fastest of processes. Depends on your machine, though...)

### Who do I talk to? ###

* Mumon