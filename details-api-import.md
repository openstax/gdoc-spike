GDocs document is pretty flat... it's an [array of paragraphs](https://developers.google.com/docs/api/reference/rest/v1/documents#StructuralElement) and each paragraph may contain [borders](https://developers.google.com/docs/api/reference/rest/v1/documents#ParagraphStyle) or other styles ([example](https://webapps.stackexchange.com/a/117682))



On the choice between importing via Word vs API , it seems like these questions would need to be answered:

- [x] How can we insert footnotes via the API? [solved](https://developers.google.com/docs/api/reference/rest/v1/documents#FootnoteReference)
- [ ] How can we insert images via the API? maybe [start here](https://developers.google.com/docs/api/reference/rest/v1/documents#InlineObjectElement)
- [ ] How can we insert equations via the API? [dead end](https://developers.google.com/docs/api/reference/rest/v1/documents#Equation)
- [ ] How can we insert equations via Word? (kinda answer: [Use LibreOffice](https://stackoverflow.com/questions/10300067/how-to-load-and-mathml-formula-into-libreoffice) in an automated way. Also see https://www.openoffice.org/xml/xml_advocacy.html "2.2")
- [ ] How can we generate styling for notes/features via Word?
- [ ] How can we generate styling for notes/features via the API? https://developers.google.com/docs/api/reference/rest/v1/documents#ParagraphStyle
