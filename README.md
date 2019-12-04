# gdoc-spike

(insert A4 card here)

# Features Table

Different import methods support different features. We cannot pick parts from different methods so we have to choose one. This table shows which features work in the different imports:

|  | [Copy/Paste custom HTML](https://docs.google.com/document/d/1_5hs7VSueGy0OZWQAkLDia-i-1a4uaqv2YZzHkE2h2M/edit) | [Word](https://docs.google.com/document/d/1xCGMgI8y0mw3Hz-3xPCqdGGqzZnaqNhP/edit) | ~HTML import~ Docs API | Drive
|--|--|--|--|--|
| Simple editable inline math: x^2 y^2 | ❌ ![image](https://user-images.githubusercontent.com/253202/69986022-12568780-1502-11ea-93b3-713122eb2551.png) [Source](https://mdn.mozillademos.org/en-US/docs/Mozilla/MathML_Project/MathML_Torture_Test$samples/MathML_Torture_Test?revision=1506691) used FireFox so that MathML would be in clipboard | ✅ | [dead end](https://developers.google.com/docs/api/reference/rest/v1/documents#Equation) |  | 
| Simple viewable inline Math: x^2 y^2 | ⚠️ ![image](https://user-images.githubusercontent.com/253202/69986777-ab39d280-1503-11ea-8bee-61c71f54549e.png) copying HTML with a PNG; alt-text did import; note the vertical alignment | ✅ (not in footnotes though) | ⚠️ somehow [inserting an image](https://developers.google.com/docs/api/reference/rest/v1/documents#InlineObjectElement) |  | 
| Complex viewable inline Math | ⚠️ ![image](https://user-images.githubusercontent.com/253202/69986981-1daab280-1504-11ea-8028-67be4e0a7554.png) copying HTML with a PNG; alt-text did import; note the vertical alignment | ✅ | ⚠️ somehow [inserting an image](https://developers.google.com/docs/api/reference/rest/v1/documents#InlineObjectElement) |  |
| Complex block math | ⚠️ ![image](https://user-images.githubusercontent.com/253202/69987214-9742a080-1504-11ea-9c48-ab6bc58be126.png) copying HTML with a PNG; alt-text did import | ⚠️ likely limited to what StarOffice Math supports | ⚠️ somehow [inserting an image](https://developers.google.com/docs/api/reference/rest/v1/documents#InlineObjectElement) |  |
| Simple footnote | ❌ | ✅ | ✅ [solved](https://developers.google.com/docs/api/reference/rest/v1/documents#FootnoteReference) |  |
| Footnote with block list, text, math, & images | ❌ | ⚠️ yes but math does not work | ⚠️ yes but math does not work |  |
| Note |  | ⚠️ yes with a table-hack | ⚠️ yes by [adding borders to paragraphs](https://developers.google.com/docs/api/reference/rest/v1/documents#ParagraphStyle) or the table hack |  |
| Note in Example | ❌ tried using border, putting it in a 1-cell table and could not find a way to "style" | ⚠️ yes, using a table hack | ⚠️ yes by [adding borders to paragraphs](https://developers.google.com/docs/api/reference/rest/v1/documents#ParagraphStyle) or the table hack |  |
| Exercise |  |  |  |  |
| Link to note |  | ⚠️ yes if it has a title (the link is to the title) | ⚠️ yes if it has a heading or we create a [bookmark](https://developers.google.com/docs/api/reference/rest/v1/documents#link) |  |
| Subfigure |  |  |  |  |
| Link to Figure | ⚠️ ![image](https://user-images.githubusercontent.com/253202/69990449-54d09200-150b-11ea-92ce-593cc0478513.png) links _always_ go to REX |  | ✅ by adding a [bookmark](https://developers.google.com/docs/api/reference/rest/v1/documents#link) |  |
| Text structure | ✅ Text structure is nicely preserved (titles, subtitles, etc)  ![atext-str.png](https://images.zenhubusercontent.com/5bc8d1f2fe40ab78d94e65fb/d44903c2-cd60-4e27-900b-4052bc2a3646)| ✅ | ✅  |   |
| Graphs, tabs, images | ✅ Are preserved in their original location and form ![green.png](https://images.zenhubusercontent.com/5bc8d1f2fe40ab78d94e65fb/1c35e8b7-a326-4cbb-b2fe-7f7af57f4fc3)| ✅ | ✅ |  | 
| Lists that begin with the number 2 | ✅ ![image](https://user-images.githubusercontent.com/253202/69991591-982c0000-150d-11ea-8d6b-af2eac473493.png) `<ol start="2">` | ✅ | ⚠️ Lists somewhere have a setting. | 
| Bullet points or list items are kept and structured | ✅ ![bulletp.png](https://images.zenhubusercontent.com/5bc8d1f2fe40ab78d94e65fb/50d3c27e-2c26-4ecc-8a1c-a34b64e55dae) | ✅ | ⚠️ Yes but not sure how to set the numbering. Each list item is a [ParagraphElement that contains a bullet field](https://developers.google.com/docs/api/reference/rest/v1/documents#Paragraph.FIELDS.bullet) |  |
