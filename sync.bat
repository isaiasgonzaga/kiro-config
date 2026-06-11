@echo off
cd /d "C:\Users\Isaias Santos\.kiro"
git add .
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "sync: atualizacao automatica de configs"
    git push
)
