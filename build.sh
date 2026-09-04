#!/usr/bin/env bash
# Builds the two outputs from the shared _head.html + _body.html sources.
#   index.html    -> standalone page for GitHub Pages / any static host
#   artifact.html -> same page as a fragment, for publishing as a Claude Artifact
set -e
cd "$(dirname "$0")"

{
  cat <<'TOP'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Teodoro Leite - mechanical and aerospace engineering student at Boston University. Perception, navigation and charting for autonomous vessels.">
<meta name="author" content="Teodoro Leite">
<meta property="og:title" content="Teodoro Leite">
<meta property="og:description" content="Perception, navigation and charting for autonomous vessels.">
<meta property="og:type" content="website">
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>%E2%9A%93</text></svg>">
TOP
  cat _head.html
  echo '</head>'
  echo '<body>'
  cat _body.html
  echo '</body>'
  echo '</html>'
} > index.html

cat _head.html _body.html > artifact.html

echo "built index.html ($(wc -c < index.html) bytes) and artifact.html ($(wc -c < artifact.html) bytes)"
