# gdoc-spike

## System Dependencies

1. Install pandoc (`brew install pandoc`)
1. Install xsltproc (`brew install libxslt`)
1. Install wget (`brew install wget`)

## Calculus Book Example

Run `./script/do-calculus.bash`. This will download the book (via `wget`) and build several `output/*.docx` files that can be uploaded to Google Docs. See the [Calculus book here](https://drive.google.com/drive/u/0/folders/16LjQx50ID4U4OEVPHz0UhdoleiYpwbhj)

### AutoLatex Version

To generate files that are able to be edited via that AutoLatex plugin, do the following:

1. Create a python virtualenv
1. Activate the virtual env and run `pip install lxml`
1. Run `./script/do-calculus.bash`
1. Check the files in `output-latex/*.docx`

## MDN Torture Tests Results

Some Formulas do not import. Here is a table indicating which formulas from the [MDN's MathML Torture Tests](https://mdn.mozillademos.org/en-US/docs/Mozilla/MathML_Project/MathML_Torture_Test$samples/MathML_Torture_Test?revision=1506691) fail to convert properly.

[Torture Tests Results Table](./torture-tests.md)

## Features Table

Different import methods support different features. We cannot pick parts from different methods so we have to choose one. 

See [./features-table.md](./features-table.md) to see which features work using different import methods.

## Single Example

1. Run `./script/html-to-docx.bash ./script/input-module.html output.docx`
1. View `output.docx` or upload it to Google Docs ([see here](https://docs.google.com/document/d/18ps6pDuzkXMbGxfZcJphinVDuALcBJyp/edit))


# Conclusions

1. Google's docx importer seems to be the most fully-featured way to import
1. Using pandoc to convert HTML to docx seems to be the easiest way since it also converts Math and Footnotes
1. XSLT moves the features (notes, examples, or other out-of-flow content) into a 1x1 HTML Table
1. Converting HTML to ePUB seems necessary in order to trigger pandoc's import of footnotes
1. We provide a `custom-reference.docx` to pandoc in order to style all the tables

# Limitations

- GDocs does not seem to have a way to include math in footnotes
- No easy way to style feature tables differently from content tables since pandoc does no t distinguish between tables
- Some math is not editable (Torture tests)
- Some math is not rendered properly (via either method)
