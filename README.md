# org-reveal-svglayers
An emacs function and a shell script that allows embedding layered svg files into reveal presentations in emacs org mode.

# Usage:

In your `.emacs` file add:
```elisp
(load "path-to-this-program/org-reveal-svglayers.el")
```

In an org-mode (reveal) file declare:
```
#+MACRO: svgf (eval (revealrstack "$1" "$2" "$3"))
```

This will create a new macro called "svgf" that will be expanded using the
emacs (elisp) function "revealstack".

The parameters work as follows:
$1: Path to the slide without the extension ".svg". The slide should be an svg file created e.g. with inkscape.
$2: Percentage of the width that will be used to scale the resulting image.
$3: Extension, either "svg" or "png".

To fix the extension for the whole presentation you can use e.g.:
```
#+MACRO: svgf (eval (revealrstack "$1" "$2" "svg"))
```

This macro can then be used as follows (e.g. for a file named 'svgfile.svg'):

```
* Test Slide
{{{svgf(images/slides/svgfile, 80%)}}}
```
