#!/usr/bin/env bash
set -e
if [[ ! -f "$1" || ! -d "$2" ]]; then
  echo "Usage: $0 <input-movie-file> <output-dir>"
  exit 1
fi

infile="$(realpath "$1")"
outdir="$(realpath "$2")"
infilename="$(basename "$infile")"

sed -e "s|ABSINPUT|$infile|" -e "s|ABSOUTPUT|$outdir|" -e "s|INFILE|$infilename|g" docker-compose.yml.template > docker-compose.yml
docker compose build
docker compose up
rm docker-compose.yml
