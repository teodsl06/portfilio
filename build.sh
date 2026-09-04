#!/usr/bin/env bash
# Builds the site from shared sources.
#
#   _head.html   shared <title>, font link and all CSS
#   _body.html   home page content
#   _kenya.html  EWB Kenya case-study content
#
# Outputs:
#   index.html / kenya.html               -> GitHub Pages (relative links, assets/ paths)
#   artifact.html / kenya-artifact.html   -> Claude Artifacts (absolute links, inline data URIs)
#
# Placeholders resolved at build time:
#   __ASSET:name__   assets/name        | data: URI
#   __HOME_URL__     index.html         | $HOME_ARTIFACT_URL
#   __KENYA_URL__    kenya.html         | $KENYA_ARTIFACT_URL
set -e
cd "$(dirname "$0")"
[ -f artifact-urls.env ] && . ./artifact-urls.env

: "${HOME_ARTIFACT_URL:=https://teodsl06.github.io/portfilio/}"
: "${KENYA_ARTIFACT_URL:=https://teodsl06.github.io/portfilio/kenya.html}"

page_head () { # $1 = title, $2 = description
  cat <<TOP
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="$2">
<meta name="author" content="Teodoro Leite">
<meta property="og:title" content="$1">
<meta property="og:description" content="$2">
<meta property="og:type" content="website">
<meta property="og:image" content="https://teodsl06.github.io/portfilio/assets/portrait.jpg">
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>%E2%9A%93</text></svg>">
TOP
}

HOME_DESC="Teodoro Leite - mechanical and aerospace engineering student at Boston University. Perception, navigation and charting for autonomous vessels."
KENYA_DESC="Hydraulics, pump sizing, filter media and solar for a borehole water system serving 1,100 people at Ogiek Secondary School, Keringet, Kenya."

{ page_head "Teodoro Leite" "$HOME_DESC"; cat _head.html; echo '</head><body>'; cat _body.html; echo '</body></html>'; } > index.html.tmp
{ page_head "Ogiek Borehole System" "$KENYA_DESC"; sed 's|<title>Teodoro Leite</title>|<title>Ogiek Borehole System</title>|' _head.html; echo '</head><body>'; cat _kenya.html; echo '</body></html>'; } > kenya.html.tmp

cat _head.html _body.html > artifact.html.tmp
{ sed 's|<title>Teodoro Leite</title>|<title>Ogiek Borehole System</title>|' _head.html; cat _kenya.html; } > kenya-artifact.html.tmp

HOME_ARTIFACT_URL="$HOME_ARTIFACT_URL" KENYA_ARTIFACT_URL="$KENYA_ARTIFACT_URL" python - <<'PY'
import base64, io, mimetypes, os, re

def build(src, dst, inline, home, kenya):
    html = io.open(src, encoding='utf-8').read()
    def asset(m):
        name = m.group(1)
        if not inline:
            return 'assets/' + name
        path = os.path.join('assets', name)
        mime = mimetypes.guess_type(path)[0] or 'application/octet-stream'
        return 'data:%s;base64,%s' % (mime, base64.b64encode(open(path, 'rb').read()).decode('ascii'))
    html = re.sub(r'__ASSET:([A-Za-z0-9_.-]+)__', asset, html)
    html = html.replace('__HOME_URL__', home).replace('__KENYA_URL__', kenya)
    io.open(dst, 'w', encoding='utf-8', newline='\n').write(html)
    os.remove(src)

H = os.environ['HOME_ARTIFACT_URL']
K = os.environ['KENYA_ARTIFACT_URL']
build('index.html.tmp',          'index.html',          False, 'index.html', 'kenya.html')
build('kenya.html.tmp',          'kenya.html',          False, 'index.html', 'kenya.html')
build('artifact.html.tmp',       'artifact.html',       True,  H, K)
build('kenya-artifact.html.tmp', 'kenya-artifact.html', True,  H, K)
PY

for f in index.html kenya.html artifact.html kenya-artifact.html; do
  echo "  $f  $(wc -c < "$f") bytes"
done
