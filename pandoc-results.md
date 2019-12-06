# Using HTML, Pandoc, & Word

In this exercise we used HTML, Pandoc, & Word to:

1. import editable math
1. add styling to denote features like "Tip" or "Everyday Connections"
1. try inserting footnotes from an HTML source file.


## tl;dr Proposal

1. Fix the RawHTML format for footnotes so they stay with the content.
1. Start with a Raw (or Baked) HTML file <sup id="a1">[[1](#f1)]</sup>
1. Run XSLT over the HTML to convert the feature into a table, or <sup id="a2">[[2](#f2)]</sup>
1. Run the HTML through Pandoc and generate a docx file <sup id="a3">[[3](#f3)]</sup>
1. Upload the docx file to GDocs


## Importing Math

Some math _can_ be imported into GDocs in an editable way using Pandoc & MS Word `.docx` file.

### Background

Pandoc [internally represents all math as Tex strings](https://hackage.haskell.org/package/pandoc-types-1.20/docs/Text-Pandoc-Definition.html#t:Inline).

Pandoc uses a package that can [read/write MathML/Tex/OfficeML](https://github.com/jgm/texmath/blob/master/src/Text/TeXMath.hs). References to it can be found by searching pandoc's source for `readMathML` or `writeOMML`.

### Method

We used [MDN's MathML Torture Tests](https://mdn.mozillademos.org/en-US/docs/Mozilla/MathML_Project/MathML_Torture_Test$samples/MathML_Torture_Test?revision=1506691) webpage & tried to import them to GDocs & make them editable.

This represents starting with our Raw/Baked HTML and importing into GDocs.

### Results

Using `HTML -> Pandoc -> docx` works for a few simple cases but the HTML Torture tests [fail to import in an editable way](https://drive.google.com/drive/u/0/folders/1FKMDFvOCqhHNlaDdgX0uKUmkl2njVk3V), maybe because they are in a table?

By using Pandoc to convert to OpenOffice first, and then using OpenOffice's `[Save As...]` we created a `.docx` to upload. This turned out [:tada: really well :tada:](https://docs.google.com/document/d/1Fa85Hkwt-zLoyc8a1esbgkRQy4PP30IH/edit), much of the equations were editable but those that were not silently failed and were just text.

In order to alert us when math cannot be converted, it seems like a `HTML -> Pandoc -> HTML` conversion may produce output when a formula cannot be converted. Here are the 1st 3 from the MDN MathML Torture Tests:

```
[WARNING] Could not convert TeX math '\frac{x + y^{2}}{k + 1}', rendering as TeX
[WARNING] Could not convert TeX math 'x + y^{\frac{2}{k + 1}}', rendering as TeX
[WARNING] Could not convert TeX math '\frac{a}{b/2}', rendering as TeX
... 100x
```


## Styling Features


### Background

Google Docs represents content as an array of Paragraphs which contains an Array of inline elements.
This means that there is no notion of a container (like a "Feature") that would contain multiple paragraphs.

Therefore, there seem to be about 2 ways to visually distinguish a feature in GDocs:

1. adding a border-top to the first "Paragraph" of a feature and a border-bottom to the last "Paragraph" (a little odd for accessibility)
1. wrapping the whole feature in a 1x1 table (odd for accessibility)


Pandoc uses an [internal representation](https://hackage.haskell.org/package/pandoc-types-1.20/docs/Text-Pandoc-Definition.html#t:Block) to convert between formats.
This representation has limitations.
Specifically, most elements (paragraphs, lists, images) do not have a way to store additional metadata (like a class name or styling information).
Only the `Div` seems to store additional metadata.

#### Example

This example shows the intermediate representation.
Note that `Div` has the id, classes, and additional `data-` attributes available to it while the `Para` does not.

```
<!DOCTYPE html><html>
<head><title>Test HTML Import</title></head>
<body>
<!-- paras in pandoc do not have attributes but divs do so there is at least a chance that we can listen to them 
$ pandoc -i thisfile.html -t native
[Div ("id123",["foo"],[("type","para"),("style","background-color:#ccc")])
 [Plain [Str "hi",Space,Str "paragraphs",Space,Str "do",Space,Str "not",Space,Str "have",Space,Str "attributes",Space,Str "in",Space,Str "pandoc"]]
,Para [Str "there"]]
-->
  <div id="id123" data-type="para" class="foo" style="background-color:#ccc">hi paragraphs do not have attributes in pandoc</div>
<p class="bar" style="background-color:#fcc">there</p>
</body>
</html>
```

Pandoc also has a way to provide plugins but at a cursory glance of the [Docx Writer](https://github.com/jgm/pandoc/blob/master/src/Text/Pandoc/Writers/Docx.hs), [pandoc filters documentation](https://pandoc.org/filters.html), and the [panflute](http://scorreia.com/software/panflute/) helper library it seems there is no gogod way to selectively affect the docx Writer. **More investigation needed**

Example: https://github.com/jgm/pandoc/blob/master/src/Text/Pandoc/Writers/Docx.hs#L623 seems to be the code that converts a Para into docx

### Method

One hacky option seems to be (from [SO](https://stackoverflow.com/a/53561308)):

1. encode anything that eventually needs styling as `[MAGIC_TEXT_BLOCK]` or something in the content
1. (maybe need to add all the custom styles into the docx .xml files that pandoc uses to generate the docx file)
1. generate a docx file via pandoc
1. use https://python-docx.readthedocs.io/ to find the `[MAGIC_TEXT_BLOCK]` and add styling to the element containing the text


### Results

TBD


## Footnotes

### Background

There is no native way to mark up footnotes in HTML.

Pandoc seems to [define a format](https://github.com/jgm/pandoc/blob/master/src/Text/Pandoc/Readers/HTML.hs#L224) when using the ePUB Reader (see `guardEnabled Ext_epub_html_exts` in the link before).

### Method

TBD


---

[<a id="f1" href="#a1"><b>1</b></a>] In order to trigger pandoc to parse footnotes, the EPUB input format needs to be used so we may have to generate an ePUB.

[<a id="f2" href="#a2"><b>2</b></a>] If nested tables is not desireable or not possible, we can encode feature names (class attributes) into `[MAGIC_BLOCK_TEXT]` and then add `border-top` and `border-bottom` to the corresponding "Paragraphs" to visually denote the feature.

[<a id="f3" href="#a3"><b>3</b></a>] Actually, the Torture Tests needed to convert to OpenOffice first. Unsure if that is always necessary
