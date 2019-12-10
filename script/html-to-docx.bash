input_file=$1
output_file=$2

if [[ $0 != "-bash" ]]; then
  cd "$(dirname "$0")/.." || exit 111
fi

xsltproc ./script/wrap-in-table.xsl "${input_file}" | pandoc --from=html --to=docx --output="${output_file}" -