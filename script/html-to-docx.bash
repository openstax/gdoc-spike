input_file=$1
output_file=$2

root_dir="$(dirname "$0")/.."

if [[ $0 != "-bash" ]]; then
  cd "$(dirname "$0")/.." || exit 111
fi

dir_name="$(dirname ${input_file})"

temp_file="${input_file}.temp.html"

cur_dir=$(pwd)

xsltproc --output "${temp_file}" ./script/wrap-in-greybox.xsl "${input_file}"

# In order to find the ../resources/*, pandoc's current directory needs to be where the HTML file is

# To create a custom reference doc run `pandoc -o custom-reference.docx --print-default-data-file reference.docx`
# Use custom table style: https://github.com/jgm/pandoc/issues/3275
x=$(cd "${dir_name}" && pandoc --reference-doc="${cur_dir}/custom-reference.docx" --from=html --to=docx --output="${cur_dir}/${output_file}" "${cur_dir}/${temp_file}")

cd "${cur_dir}"

rm "${temp_file}"