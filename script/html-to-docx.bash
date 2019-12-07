input_file=$1
output_file=$2

xsltproc wrap-in-table.xsl "${input_file}" | pandoc --from=html --to=docx --output="${output_file}" -