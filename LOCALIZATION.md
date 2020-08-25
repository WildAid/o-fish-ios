Localization files are in Localization/CODE.lkproj/Localizable.strings
e.g.
Localization/es-419/Localizable.strings
Localization/fr/Localizable.strings

The format is:
The string found in the code (English) 
=
The string to localize to
;

e.g.:
"Yes" = "Oui";

To see if a file has any non-translated items
Run this to find all the strings that are the same on both sides of the equals sign:
`cut -f1 -d\= Localizable.strings > first; cut -f2 -d\= Localizable.strings | sed 's/.$//' > last  ; diff -wy first last | grep -v \|`

This may give some false positives, e.g. in French, "Photo" and "Date" are the same in English and French.
