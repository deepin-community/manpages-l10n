# Adding a new language

If you create a new language, remember to complete the following steps:


* Create a suitable language directory under po with the official language
  code, e.g. `fr/` for French.

* Create the subdirectories for the .po files (man1 … man8)

* Copy the _common_ directory from _templates/_ to your language directory and
  rename the containing files from .pot to .po.

* __Important:__ Import a translation file (.po file) to the compendium using
  ../use-for-compendium.sh. For best quality in terms of consistence, you might use
  the [translation of help2man](http://translationproject.org/domain/help2man.html)
  for the target language &ndash; as far as available. Otherwise, edit one of the files
  in _common/_ manually (copying some messages which don't have translatable content),
  to have at least a few gettext messages translated.

* Create a file named lang.config in your language subdirectory with the following
  content (this example uses the hypothetical case of English):

```
   langcode="en"
   langname="English"
   langname_translated="English"
   hint1=", "
   hint2="strings missing until 80%"
   langmail="English <debian-l10n-english@lists.debian.org>"
```

* Copy and adapt license-groff.add, license-mdoc.add, translate-dates.pl and generate-addendum.sh.

* If addenda does not (yet) work, create the file _noaddendum_ in the language
  directory.

* In `public/`, open one file of each name scheme `distribution-xx.stub`, `index-xx.stub`,
  `setup-xx.inc`, and `untranslated-xx.stub`. Save the files replacing the previous
  language code in the file names with the actual code of your target langauge, then
  look in the files for any occurence of the previous language and replace it. For the
  time zone definition in `setup-xx.inc`, look for a suitable value in the
  [time zone database](https://www.iana.org/time-zones). In `generate-stats-page.sh`,
  add a link to the language directory (just copy one of the other lines and replace the
  previous values). Finally, add the new language code to the following line in
  `generate-stats-page.sh`:

```
   for tlang in cs … sv; do
```

