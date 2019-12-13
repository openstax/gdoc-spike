from __future__ import print_function
from builtins import str
from lxml import etree
import os
import io

def force_math_namespace_only(doc):
    # http://wiki.tei-c.org/index.php/Remove-Namespaces.xsl
    xslt=u'''<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1998/Math/MathML">
    <xsl:output method="xml" indent="no"/>

    <xsl:template match="/|comment()|processing-instruction()">
        <xsl:copy>
          <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{local-name()}">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
          <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    </xsl:stylesheet>
    '''

    xslt_doc = etree.parse(io.StringIO(xslt))
    transform = etree.XSLT(xslt_doc)
    doc = transform(doc)
    return doc

def mathml2latex_yarosh(equation):
    """ MathML to LaTeX conversion with XSLT from Vasil Yaroshevich """
    script_base_path = os.path.dirname(os.path.realpath(__file__))
    xslt_file = os.path.join(script_base_path, 'xsl_yarosh', 'mmltex.xsl')
    dom = etree.fromstring(equation)
    xslt = etree.parse(xslt_file)
    transform = etree.XSLT(xslt)
    newdom = transform(dom)
    return str(newdom)

def main():
    f = etree.parse("2-5-Quadratic-Equations.xhtml")
    ns = {"h": "http://www.w3.org/1999/xhtml",
          "m": "http://www.w3.org/1998/Math/MathML"}
    for r in f.xpath('//h:math|//m:math', namespaces=ns):
        math_etree = force_math_namespace_only(r)
        equation = etree.tostring(math_etree, with_tail=False, inclusive_ns_prefixes=None)
        # print(equation)
        autolatex = '$' + mathml2latex_yarosh(equation) + '$'
        if (autolatex[1] != '$'):
            autolatex = '$' + autolatex + '$'
        r.tail = autolatex + r.tail if r.tail else autolatex
    etree.strip_elements(f,'{http://www.w3.org/1999/xhtml}math', with_tail=False)
    etree.strip_elements(f,'{http://www.w3.org/1998/Math/MathML}math', with_tail=False)
    print(etree.tostring(f,pretty_print=True).decode('utf-8'))

if __name__== "__main__":
    main()
