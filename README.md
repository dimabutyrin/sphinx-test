# sphinx-test
Bash script for sphinx testing, run queries from sphinx-queries.txt one by one or all at a time.
Enable query_log in sphinx.conf and run searchd with "--cpustats --iostats" for analysis.

For sending same queries n times use this cycle in bash shell:
for i in {1..n}; do ./sphinx-test.sh all some.domain.name; done
