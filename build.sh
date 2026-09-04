#!/usr/bin/env bash
# Builds the two outputs from the shared _head.html + _body.html sources.
#   index.html    -> standalone page for GitHub Pages / any static host
#   artifact.html -> same page as a fragment, for publishing as a Claude Artifact
#
# Images are written once in _body.html as __ASSET:filename__ placeholders.
# index.html gets a relative assets/ path; artifact.html gets an inline data URI,
# because a published Artifact cannot fetch files next to it.
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
<meta property="og:image" content="https://teodsl06.github.io/portfilio/assets/portrait.jpg">
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>%E2%9A%93</text></svg>">
TOP
  cat _head.html
  echo '</head>'
  echo '<body>'
  cat _body.html
  echo '</body>'
  echo '</html>'
} > index.html.tmp

cat _head.html _body.html > artifact.html.tmp

python - <<'PY'
import base64, io, mimetypes, os, re

def sub(src, dst, inline):
    html = io.open(src, encoding='utf-8').read()
    def repl(m):
        name = m.group(1)
        if not inline:
            return 'assets/' + name
        path = os.path.join('assets', name)
        mime = mimetypes.guess_type(path)[0] or 'application/octet-stream'
        data = base64.b64encode(open(path, 'rb').read()).decode('ascii')
        return 'data:%s;base64,%s' % (mime, data)
    html = re.sub(r'__ASSET:([A-Za-z0-9_.-]+)__', repl, html)
    io.open(dst, 'w', encoding='utf-8', newline='\n').write(html)
    os.remove(src)

sub('index.html.tmp', 'index.html', inline=False)
sub('artifact.html.tmp', 'artifact.html', inline=True)
PY

echo "built index.html ($(wc -c < index.html) bytes) and artifact.html ($(wc -c < artifact.html) bytes)"
