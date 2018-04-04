createdb papers
psql -d papers -f papers.sql

# rm 'papers.db'
# cat 'papers.sql' | sqlite3 'papers.db'