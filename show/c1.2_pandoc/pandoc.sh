#!/bin/bash

pandoc WEBSITE.md -o website.html
pandoc WEBSITE.md -o website.docx
pandoc WEBSITE.md -o website.pdf --latex-engine=xelatex -V mainfont="WenQuanYi Micro Hei"
