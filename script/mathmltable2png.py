from lxml import etree
import os
import io
import sys
import requests


def force_math_namespace_only(doc):
    # http://wiki.tei-c.org/index.php/Remove-Namespaces.xsl
    xslt = u'''<xsl:stylesheet
      version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns="http://www.w3.org/1998/Math/MathML">
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


def _strip_mathjax_container(svg):
    xslt = u'''<xsl:stylesheet
      version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns="http://www.w3.org/1998/Math/MathML">
    <xsl:output method="xml" indent="no"/>

    <xsl:template match="mjx-container">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    </xsl:stylesheet>
    '''
    xslt_doc = etree.parse(io.StringIO(xslt))
    svg_xml = etree.parse(io.StringIO(svg))
    transform = etree.XSLT(xslt_doc)
    svg_xml = transform(svg_xml)
    bytes_svg = etree.tostring(svg_xml, with_tail=False)
    pure_svg = str(bytes_svg, 'utf-8')
    return pure_svg


def mathml2svg_jsonrpc(equation):
    url = "http://localhost:3000/jsonrpc"
    payload = {
        "method": "mathml2svg",
        "params": [equation],
        # "params": ["xyz"],
        "jsonrpc": "2.0",
        "id": 0,
    }

    response = requests.post(url, json=payload).json()

    if not 'result' in response:
        # something went terrible wrong with calling the jsonrpc server and running the command
        print('No result in calling mml2svg jayson/json-rpc server!')
        sys.exit(1)
        return ''
    else:
        svg = response['result']
        if len(svg) > 0:
            svg = _strip_mathjax_container(svg)
        return svg

def svg2png_jsonrpc(svg):
    url = "http://localhost:3000/jsonrpc"
    payload = {
        "method": "svg2png",
        "params": [svg],
        "jsonrpc": "2.0",
        "id": 0,
    }

    response = requests.post(url, json=payload).json()

    if not 'result' in response:
        # something went terrible wrong with calling the jsonrpc server and running the command
        print('No result in calling mml2svg jayson/json-rpc server!')
        sys.exit(1)
        return ''
    else:
        svg = response['result']
        if len(svg) > 0:
            svg = _strip_mathjax_container(svg)
        return svg


def main():
    if sys.version_info[0] < 3:
        raise Exception("Must be using Python 3")
    f = etree.parse("/Users/marvin/openstax/gdoc-spike/3.3-nice/nice.html")
    # f = etree.parse(sys.argv[1])
    ns = {"h": "http://www.w3.org/1999/xhtml",
          "m": "http://www.w3.org/1998/Math/MathML"}
    for r in f.xpath('//h:math[descendant::h:mtable]|//m:math[descendant::m:mtable]', namespaces=ns):
        try:
            math_etree = force_math_namespace_only(r)
            bytes_equation = etree.tostring(
                math_etree, with_tail=False, inclusive_ns_prefixes=None)
            # convert bytes string from lxml to utf-8
            equation = str(bytes_equation, 'utf-8')
            svg = mathml2svg_jsonrpc(equation)
            # print(svg)
            png = svg2png_jsonrpc(svg)
            print(png[0:5])
            print('=' * 50)
        finally:
            pass  # TODO: handle exceptions better
    # etree.strip_elements(
    #     f, '{http://www.w3.org/1999/xhtml}math', with_tail=False)
    # etree.strip_elements(
    #     f, '{http://www.w3.org/1998/Math/MathML}math', with_tail=False)
    # print(etree.tostring(f, pretty_print=True).decode('utf-8'))


if __name__ == "__main__":
    main()
