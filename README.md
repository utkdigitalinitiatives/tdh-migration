# Tennessee Documentary History Migration Project #

## What ##
See [Project Notes and Plan](https://jirautk.atlassian.net/wiki/spaces/DLP/pages/58196091/Tennessee+Documentary+History+Migration+Project+Plan).

This is a TEI collection migration from P2 SGML/XML to P5.

## Notes and Errata ##
1. Notes from an old set of notes in the working directory from 2013:
   1. check `<gap>` elements.
   2. check anything else?
   3. `<p>` outside of `<table>` in `pav.xml`.
   4. what else?
2. Errata: this is a partial snapshot of incomplete work from several years ago (2013-2014). The some of the files in [sgml-scripts](original-data/sgml-scripts) are incomplete, or meant to be run as sequential shell commands (and I don't distinctly remember the context/sequence).
3. Errata Con't: the original files (a mix of SGML and XML) are in [sgml](original-data/sgml). The reference DTD, `TEILITE1.DTD`, is gone, lost to time, so validation for the SGML will be difficult (there are ways to generate a DTD from sources, but I'm not prepared to invest that time right now. Maybe that's bad.). However, we do have the DTD referenced in the XML.
4. Notes: Sebastian Rahtz has produced a really nice starting point XSL stylesheet for converting P4 TEI to P5. This is included in [tei-scripts](original-data/tei-scripts).
