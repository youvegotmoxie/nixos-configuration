file="$1"
line="$2"
context="${3:-3}"

base_command='git --no-pager diff --no-color HEAD'

# Print only the hunk whose +start,len covers $line
eval "$base_command" -U"$context" -- "$file" |
    awk -v ln="$line" '
  BEGIN { have=0; buf=""; out="" }
  /^@@ /{
# stash the first matching hunk
   if (have && out=="") { out=buf }
    buf = $0 ORS
    have = 0
    # Extract +start[,len] from header
    header = $0
    sub(/^.*\+/, "", header)
    sub(/ .*/, "", header)
    n = split(header, parts, ",")
    s = parts[1] + 0
    l = (n >= 2 ? parts[2] + 0 : 1)
    have = (l == 0 ? (ln == s) : (ln >= s && ln < s + l))
    next
  }
  { if (buf != "") buf = buf $0 ORS }
  END {
    if (have && out=="") out=buf
    if (out != "") print out; else print "No hunk under cursor"
  }
'
