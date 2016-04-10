# README #

These are my personal dotfile(s) and some (more or less) useful scripts I wrote. My bash .profile is optimized towards Mac OS X, but many of the aliases and functions work on Linux as well (with additional dependencies installed using a package installer of your choosing).

### What is this repository for? ###

* just messin' around with dotfiles
* easy command-line-based encryption and decryption of files and directories
* OCR your PDFs with tesseract and output either searchable PDFs (pdftopdf) or plain text (pdftotxt)
* more coming...

### How do I get set up? ###

* homebrew or MacPorts on Mac, or the package installer of your Linux distro
* The encrypt and decrypt functions are basically wrapper around _openssl_, so they should be useable out-of-the-box on your machines!
* For the OCR functions, you need tesseract, pdftk, and ImageMagick with all their dependencies. I do not use any custom-trained models for tesseract, so it's suited for any language you like (with all the potential limitations of the default models, however).

### Who do I talk to? ###

* Mumon