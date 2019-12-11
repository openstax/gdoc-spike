# set -e

archive_book_url="https://archive.cnx.org/contents/8b89d172-2927-466f-8661-01abc7ccdba4@7.4"

if [[ $0 != "-bash" ]]; then
  cd "$(dirname "$0")/.." || exit 111
fi


wget ${archive_book_url} --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/*;q=0.8" --base=${archive_book_url} --mirror --force-html --continue --timeout=45 --convert-links --recursive --page-requisites --no-parent --domains=cnx.org
exit_status=$?
if [[ ${exit_status} != 0 && ${exit_status} != 8 ]]; then
  echo "wget encountered an error. The status code was ${exit_status}"
  exit 111
fi

echo "Renaming resources to not include the filename"

all_files=$(find archive.cnx.org/resources -type f)

echo "${all_files}"

for filename in ${all_files}; do
  dirname=$(dirname ${filename})

  # If the destination (dirname) exists then do not rename
  if [[ ${dirname} == 'archive.cnx.org/resources' ]]; then
    echo "Skipping ${filename}"
  else
    echo "renaming ${filename} to ${dirname}"

    mv ${filename} temp.image || exit 111
    rm -rf ${dirname} || exit 111
    mv temp.image ${dirname} || exit 111
  fi
done
