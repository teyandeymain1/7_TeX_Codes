$latex = 'uplatex --shell-escape -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error %O %S';
$lualatex = 'lualatex -synctex=1 -interaction=nonstopmode -file-line-error -halt-on-error --shell-escape %S';
$bibtex = 'upbibtex %O %S';

$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'makeindex %O -o %D %S';

# uplatexは3,lualatexは4
$pdf_mode = 3;
$max_repeat = 10;