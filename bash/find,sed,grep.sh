######### What this is #########
# This is NOT a script, but rather a collection of handy one-liners,
# for various common tasks like renaming variables.

# Find and replace without touching unmodified files.
# (Otherwise `make` acts as if everything needs to be rerun.)
# https://stackoverflow.com/questions/27071019/sed-i-touching-files-that-it-doesnt-change
for i in *; do grep mytext $i && sed -i -e 's/mytext/replacement/g' $i; done

# Find and replace in all files.
find . -name "*.py" -print0 | xargs -0 sed -i "s/prop.2018.11.31/prop_2018_10_31/g"

# find all files in a certain set of types (file extensions)
find . -regex ".*\.\(yaml\|txt\)"

# Find and replace.
sed -i "s/python\/vat\/report/python\/report/g" Makefile

# Count lines added or deleted in the diff, ignore blank lines.
# (This is the sum of additions and subtractions, not their difference.)
git diff | egrep -v "^.$" | egrep "^\+" | wc

# Find in all files of one particular type.
grep -i "todo" -r . --include="*.py"
# Find (case-insensitive) in all files of many types
find . -regex ".*\.\(py\|txt\|sh\|org\|mm\|md\|hs\)" -print0 | xargs -0 grep -i "todo"

# Delete all files ending in "~" (the suffix on backups).
find . -name "*~" -print0 | xargs -0 rm
