# Silkscreen

Silkscreen take Markdown files and convert to Fullpages slides in html. See the [example site](https://carlosfrodrigues.github.io/silkscreen-example/).

### How to use
```sh
silkscreen yourmarkdownfile.md
```
It will generate on the same directory a HTML file with the same name of the markdown file.

### Install
You need Cabal to install, run on the silkscreen directory:
```sh
cabal install
```
It will install silkscreen and the CMark library dependency.

### Configuration
There are two files inside the config folder:
* colors: A file where each line has a HEX color.The colors are used in the background in repeat. You can edit this file choosing the colors you want.
* template.silk: the HTML template used to generate the fullpage.

### Easter Egg
Try running silkscreen with the flag `--weezer`.
