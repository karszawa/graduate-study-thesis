# Description

There are source files of my thesis.

# Usage

These are commands to compile latex files.

## build

```
rake build
```

## clean

```
rake clean
```

## open pdf

```
rake open
```

## build and clean

```
rake
```

# Dependency

```
$ rake --version
rake, version 0.9.6

$ pandoc --version
pandoc 1.15.2.1

$ latexmk --version
Latexmk, John Collins, 5 February 2015. Version 4.43a
```

.latexmkrc
```
#!/usr/bin/env perl
$latex = 'platex -synctex=1 -halt-on-error';
$latex_silent = 'platex -synctex=1 -halt-on-error -interaction=batchmode';
$bibtex = 'pbibtex';
$biber = 'biber --bblencoding=utf8 -u -U --output_safechars';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';
$max_repeat = 5;
$pdf_mode	= 3; # generates pdf via dvipdfmx

# Prevent latexmk from removing PDF after typeset.
# This enables Skim to chase the update in PDF automatically.
$pvc_view_file_via_temporary = 0;

# Use Skim as a previewer
$pdf_previewer    = 'open -ga /Applications/Skim.app';

# Exploit $pdf_update_command when compiling
$pdf_update_method = 4;

# Call notification
$pdf_update_command = "osascript -e 'display notification \"Compiled\" with title \"LaTeX\"'";
```