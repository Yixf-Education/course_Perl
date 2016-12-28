csvsql --query "select Population from country where Country=='France'" country.txt | csvlook
echo "\n"
csvgrep -t -c Country -m France country.txt | csvcut -c Population | csvlook
