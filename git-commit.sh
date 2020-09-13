#!/bin/bash
read -p "Comments for your commit: " commit_comments
git add .
git status
git commit -m "$commit_comments"
git push -u origin master
