<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/i18n/UnicodeChart
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<center><h3>Code Charts</h3></center>
<p align="center">The charts in this list are arranged in code point order.</p>
<table class="altClass">
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U004C.gif"
                align="middle" hspace="8" alt="Chart starts at 0000" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0000">Basic
      Latin</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2440.gif"
                align="middle" hspace="8" alt="Chart starts at 2440" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2440">Optical
      Character Recognition</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U004C.gif"
                align="middle" hspace="8" alt="Chart starts at 0080" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0080">Latin-1
      Supplement</a></td>
    <td><img src="http://www.unicode.org/charts/img/U24B6.gif"
                align="middle" hspace="8" alt="Chart starts at 2460" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2460">Enclosed
      Alphanumerics</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U004C.gif"
                align="middle" hspace="8" alt="Chart starts at 0100" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0100">Latin
      Extended-A</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2557.gif"
                align="middle" hspace="8" alt="Chart starts at 2500" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2500">Box
      Drawing</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U004C.gif"
                align="middle" hspace="8" alt="Chart starts at 0180" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0180">Latin
      Extended-B</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2580.gif"
                align="middle" hspace="8" alt="Chart starts at 2580" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2580">Block
      Elements</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0259.gif"
                align="middle" hspace="8" alt="Chart starts at 0250" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0250">IPA
      Extensions</a></td>
    <td><img src="http://www.unicode.org/charts/img/U25C8.gif"
                align="middle" hspace="8" alt="Chart starts at 25A0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=25A0">Geometric
      Shapes</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U02C6.gif"
                align="middle" hspace="8" alt="Chart starts at 02B0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=02B0">Spacing
      Modifier Letters</a></td>
    <td><img src="http://www.unicode.org/charts/img/U263A.gif"
                align="middle" hspace="8" alt="Chart starts at 2600" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2600">Miscellaneous
      Symbols</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U030C.gif"
                align="middle" hspace="8" alt="Chart starts at 0300" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0300">Combining
      Diacritical Marks</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2708.gif"
                align="middle" hspace="8" alt="Chart starts at 2700" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2700">Dingbats</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U03A9.gif"
                align="middle" hspace="8" alt="Chart starts at 0370" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0370">Greek</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2286.gif"
                align="middle" hspace="8" alt="Chart starts at 27D0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=27C0">Miscellaneous
      Mathematical Symbols-A</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U042F.gif"
                align="middle" hspace="8" alt="Chart starts at 0400" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0400">Cyrillic</a></td>
    <td><img src="http://www.unicode.org/charts/img/U21C5.gif"
                align="middle" hspace="8" alt="Chart starts at 27F0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=27F0">Supplemental
      Arrows-A</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U042F.gif"
                align="middle" hspace="8" alt="Chart starts at 0500" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0500">Cyrillic
      Supplement</a></td>
    <td><img src="http://www.unicode.org/charts/img/U281D.gif"
                align="middle" hspace="8" alt="Chart starts at 2800" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2800">Braille
      Patterns</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0543.gif"
                align="middle" hspace="8" alt="Chart starts at 0530" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0530">Armenian</a></td>
    <td><img src="http://www.unicode.org/charts/img/U21C5.gif"
                align="middle" hspace="8" alt="Chart starts at 2900" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2900">Supplemental
      Arrows-B</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U05D0.gif"
                align="middle" hspace="8" alt="Chart starts at 0590" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0590">Hebrew</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2286.gif"
                align="middle" hspace="8" alt="Chart starts at 2980" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2980">Miscellaneous
      Mathematical Symbols-B</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0634.gif"
                align="middle" hspace="8" alt="Chart starts at 0600" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0600">Arabic</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2286.gif"
                align="middle" hspace="8" alt="Chart starts at 2A00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2A00">Supplemental
      Mathematical Operators</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0710.gif"
                align="middle" hspace="8" alt="Chart starts at 0700" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0700">Syriac</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2F27.gif"
                align="middle" hspace="8" alt="Chart starts at 2E80" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2E80">CJK
      Radicals Supplement</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0781.gif"
                align="middle" hspace="8" alt="Chart starts at 0780" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0780">Thaana</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2F27.gif"
                align="middle" hspace="8" alt="Chart starts at 2F00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2F00">Kangxi
      Radicals</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0915.gif"
                align="middle" hspace="8" alt="Chart starts at 0900" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0900">Devanagari</a></td>
    <td><img src="http://www.unicode.org/charts/img/U2FF0.gif"
                align="middle" hspace="8" alt="Chart starts at 2FF0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2FF0">Ideographic
      Description Characters</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0995.gif"
                align="middle" hspace="8" alt="Chart starts at 0980" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0980">Bengali</a></td>
    <td><img src="http://www.unicode.org/charts/img/U3020.gif"
                align="middle" hspace="8" alt="Chart starts at 3000" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=3000">CJK
      Symbols and Punctuation</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0A15.gif"
                align="middle" hspace="8" alt="Chart starts at 0A00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0A00">Gurmukhi</a></td>
    <td><img src="http://www.unicode.org/charts/img/U304B.gif"
                align="middle" hspace="8" alt="Chart starts at 3040" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=3040">Hiragana</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0A95.gif"
                align="middle" hspace="8" alt="Chart starts at 0A80" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0A80">Gujarati</a></td>
    <td><img src="http://www.unicode.org/charts/img/U30AB.gif"
                align="middle" hspace="8" alt="Chart starts at 30A0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=30A0">Katakana</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0B15.gif"
                align="middle" hspace="8" alt="Chart starts at 0B00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0B00">Oriya</a></td>
    <td><img src="http://www.unicode.org/charts/img/U3105.gif"
                align="middle" hspace="8" alt="Chart starts at 3100" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=3100">Bopomofo</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0B95.gif"
                align="middle" hspace="8" alt="Chart starts at 0B80" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0B80">Tamil</a></td>
    <td><img src="http://www.unicode.org/charts/img/U314E.gif"
                align="middle" hspace="8" alt="Chart starts at 3130" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=3130">Hangul
      Compatibility Jamo</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0C15.gif"
                align="middle" hspace="8" alt="Chart starts at 0C00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0C00">Telugu</a></td>
    <td><img src="http://www.unicode.org/charts/img/U3199.gif"
                align="middle" hspace="8" alt="Chart starts at 3190" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=3190">Kanbun</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0C95.gif"
                align="middle" hspace="8" alt="Chart starts at 0C80" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0C80">Kannada</a></td>
    <td><img src="http://www.unicode.org/charts/img/U3105.gif"
                align="middle" hspace="8" alt="Chart starts at 31A0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=31A0">Bopomofo
      Extended</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0D15.gif"
                align="middle" hspace="8" alt="Chart starts at 0D00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0D00">Malayalam</a></td>
    <td><img src="http://www.unicode.org/charts/img/U322D.gif"
                align="middle" hspace="8" alt="Chart starts at 3200" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=3200">Enclosed
      CJK Letters and Months</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0D85.gif"
                align="middle" hspace="8" alt="Chart starts at 0D80" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0D80">Sinhala</a></td>
    <td><img src="http://www.unicode.org/charts/img/U3300.gif"
                align="middle" hspace="8" alt="Chart starts at 3300" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=3300">CJK
      Compatibility</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0E04.gif"
                align="middle" hspace="8" alt="Chart starts at 0E00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0E00">Thai</a></td>
    <td><img src="http://www.unicode.org/charts/img/U5B57.gif"
                align="middle" hspace="8" alt="Chart starts at 3400" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=3400">CJK
      Unified Ideographs Extension A (1.5MB)</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0E82.gif"
                align="middle" hspace="8" alt="Chart starts at 0E80" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0E80">Lao</a></td>
    <td><img src="http://www.unicode.org/charts/img/U5B57.gif"
                align="middle" hspace="8" alt="Chart starts at 4E00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=4E00">CJK
      Unified Ideographs (5MB)</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U0F40.gif"
                align="middle" hspace="8" alt="Chart starts at 0F00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=0F00">Tibetan</a></td>
    <td><img src="http://www.unicode.org/charts/img/UA48F.gif"
                align="middle" hspace="8" alt="Chart starts at A000" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=A000">Yi
      Syllables</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U1000.gif"
                align="middle" hspace="8" alt="Chart starts at 1000" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1000">Myanmar</a></td>
    <td><img src="http://www.unicode.org/charts/img/UA48F.gif"
                align="middle" hspace="8" alt="Chart starts at A490" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=A490">Yi
      Radicals</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U10D3.gif"
                align="middle" hspace="8" alt="Chart starts at 10A0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=10A0">Georgian</a></td>
    <td><img src="http://www.unicode.org/charts/img/UAC00.gif"
                align="middle" hspace="8" alt="Chart starts at AC00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=AC00">Hangul
      Syllables (7MB)</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U1112.gif"
                align="middle" hspace="8" alt="Chart starts at 1100" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1100">Hangul
      Jamo</a></td>
    <td><img src="http://www.unicode.org/charts/img/UYYYYY.gif"
                align="middle" hspace="8" alt="High Surrogates start at D800"
                width="25" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=D800">High
      Surrogates</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U1211.gif"
                align="middle" hspace="8" alt="Chart starts at 1200" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1200">Ethiopic</a></td>
    <td><img src="http://www.unicode.org/charts/img/UWWWWW.gif"
                align="middle" hspace="8" alt="Low Surrogates start at DC00"
                width="26" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=DC00">Low
      Surrogates</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U13C4.gif"
                align="middle" hspace="8" alt="Chart starts at 13A0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=13A0">Cherokee</a></td>
    <td><img src="http://www.unicode.org/charts/img/UVVVVV.gif"
                align="middle" hspace="8" alt="Private Use Area starts at E000"
                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=E000">Private
      Use Area</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U1555.gif"
                align="middle" hspace="8" alt="Chart starts at 1400" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1400">Unified
      Canadian Aboriginal Syllabic</a></td>
    <td><img src="http://www.unicode.org/charts/img/U5B57.gif"
                align="middle" hspace="8" alt="Chart starts at F900" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=F900">CJK
      Compatibility Ideographs</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U1689.gif"
                align="middle" hspace="8" alt="Chart starts at 1680" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1680">Ogham</a></td>
    <td><img src="http://www.unicode.org/charts/img/UFB01.gif"
                align="middle" hspace="8" alt="Chart starts at FB00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=FB00">Alphabetic
      Presentation Forms</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U16A0.gif"
                align="middle" hspace="8" alt="Chart starts at 16A0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=16A0">Runic</a></td>
    <td><img src="http://www.unicode.org/charts/img/UFD37.gif"
                align="middle" hspace="8" alt="Chart starts at FB50" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=FB50">Arabic
      Presentation Forms-A</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U004C.gif"
                align="middle" hspace="8" alt="Chart starts at 1700" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1700">Tagalog</a></td>
    <td><img src="http://www.unicode.org/charts/img/UFFFD.gif"
                align="middle" hspace="8" alt="Chart starts at FE00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=FE00">Variation
      Selectors</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U004C.gif"
                align="middle" hspace="8" alt="Chart starts at 1720" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1720">Hanunoo</a></td>
    <td><img src="http://www.unicode.org/charts/img/UFE20.gif"
                align="middle" hspace="8" alt="Chart starts at FE20" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=FE20">Combining
      Half Marks</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U004C.gif"
                align="middle" hspace="8" alt="Chart starts at 1740" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1740">Buhid</a></td>
    <td><img src="http://www.unicode.org/charts/img/UFE43.gif"
                align="middle" hspace="8" alt="Chart starts at FE30" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=FE30">CJK
      Compatibility Forms</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U004C.gif"
                align="middle" hspace="8" alt="Chart starts at 1760" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1760">Tagbanwa</a></td>
    <td><img src="http://www.unicode.org/charts/img/UFE5D.gif"
                align="middle" hspace="8" alt="Chart starts at FE50" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=FE50">Small
      Form Variants</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U1780.gif"
                align="middle" hspace="8" alt="Chart starts at 1780" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1780">Khmer</a></td>
    <td><img src="http://www.unicode.org/charts/img/UFEB8.gif"
                align="middle" hspace="8" alt="Chart starts at FE70" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=FE70">Arabic
      Presentation Forms-B</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U185E.gif"
                align="middle" hspace="8" alt="Chart starts at 1800" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1800">Mongolian</a></td>
    <td><img src="http://www.unicode.org/charts/img/UFF76.gif"
                align="middle" hspace="8" alt="Chart starts at FF00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=FF00">Halfwidth
      and Fullwidth Forms</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U004C.gif"
                align="middle" hspace="8" alt="Chart starts at 1E00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1E00">Latin
      Extended Additional</a></td>
    <td><img src="http://www.unicode.org/charts/img/UFFFD.gif"
                align="middle" hspace="8" alt="Chart starts at FFF0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=FFF0">Specials</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U03A9.gif"
                align="middle" hspace="8" alt="Chart starts at 1F00" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1F00">Greek
      Extended</a></td>
    <td><img src="http://www.unicode.org/charts/img/OldItalic.gif"
                align="middle" hspace="8" alt="Chart starts at 10300"
                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=10300">Old
      Italic</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U201C.gif"
                align="middle" hspace="8" alt="Chart starts at 2000" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2000">General
      Punctuation</a></td>
    <td><img height="24" width="24"
                src="http://www.unicode.org/charts/img/Gothic.gif"
                align="middle" hspace="8" alt="Chart starts at 10330"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=10330">Gothic</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U00B2.gif"
                align="middle" hspace="8" alt="Chart starts at 2070" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2070">Superscripts
      and Subscripts</a></td>
    <td><img src="http://www.unicode.org/charts/img/Deseret.gif"
                align="middle" hspace="8" alt="Chart starts at 10400"
                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=10400">Deseret</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U20AC.gif"
                align="middle" hspace="8" alt="Chart starts at 20A0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=20A0">Currency
      Symbols</a></td>
    <td><img src="http://www.unicode.org/charts/img/ByzMusic.gif"
                align="middle" hspace="8" alt="Chart starts at 1D000"
                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1D000">Byzantine
      Musical Symbols</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U20D5.gif"
                align="middle" hspace="8" alt="Chart starts at 20D0" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=20D0">Combining
      Marks for Symbols</a></td>
    <td><img src="http://www.unicode.org/charts/img/Music.gif"
                align="middle" hspace="8" alt="Chart starts at 1D100"
                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1D100">Musical
      Symbols</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U2122.gif"
                align="middle" hspace="8" alt="Chart starts at 2100" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2100">Letterlike
      Symbols</a></td>
    <td><img height="24" width="24"
                src="http://www.unicode.org/charts/img/MathAlpha.gif"
                align="middle" hspace="8" alt="Chart starts at 1D400"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=1D400">Mathematical
      Alphanumeric Symbols</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U2153.gif"
                align="middle" hspace="8" alt="Chart starts at 2150" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2150">Number
      Forms</a></td>
    <td><img src="http://www.unicode.org/charts/img/U5B57.gif"
                align="middle" hspace="8" alt="Chart starts at 20000"
                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=20000">CJK
      Unified Ideographs Extension B (13MB)</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U21C5.gif"
                align="middle" hspace="8" alt="Chart starts at 2190" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2190">Arrows</a></td>
    <td><img src="http://www.unicode.org/charts/img/U5B57.gif"
                align="middle" hspace="8" alt="Chart starts at 2F800"
                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2F800">CJK
      Compatibility Ideographs Supplement</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U2286.gif"
                align="middle" hspace="8" alt="Chart starts at 2200" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2200">Mathematical
      Operators</a></td>
    <td><img src="http://www.unicode.org/charts/img/Tags.gif"
                align="middle" hspace="8" alt="Chart starts at E0000"
                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=E0000">Tags</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/U2331.gif"
                align="middle" hspace="8" alt="Chart starts at 2300" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2300">Miscellaneous
      Technical</a></td>
    <td><img src="http://www.unicode.org/charts/img/UVVVVV.gif"
                align="middle" hspace="8"
                alt="Supplementary Private Use Area-A starts at F0000"
                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=F0000">Supplementary
      Private Use Area-A</a></td>
  </tr>
  <tr>
    <td><img src="http://www.unicode.org/charts/img/UXXXXX.gif"
                align="middle" hspace="8" alt="Chart starts at 2400" width="24"
                height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=2400">Control
      Pictures</a></td>
    <td><img src="http://www.unicode.org/charts/img/UVVVVV.gif"
                align="middle" hspace="8"
                alt="Supplementary Private Use Area-B starts at 100000"

                width="24" height="24"><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeTable&#38;start=100000">Supplementary
      Private Use Area-B</a></td>
  </tr>
</table>
</cs:ftcs>
