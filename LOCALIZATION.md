Localization files are in `Localization/CODE.lproj/Localizable.strings`<BR>
e.g.<BR>
`Localization/es-419/Localizable.strings`<BR>
`Localization/fr/Localizable.strings`<BR><BR>

The format is:<BR>
The string found in the code (English)<BR>
=<BR>
The string to localize to<BR>
;<BR><BR>

e.g.:<BR>
"Yes" = "Oui";<BR><BR>

If you copy the English translation and fill in translations, and want to see if a file has any non-translated items<BR>
Run this to find all the strings that are the same on both sides of the equals sign:<BR>
`cut -f1 -d\= Localizable.strings > first && cut -f2 -d\= Localizable.strings | sed 's/.$//' > last && diff -wy first last | grep -v \| && rm first last`<BR><BR>

This may give some false positives, e.g. in French, "Photo" and "Date" are the same in English and French.
