#!/bin/bash

gpg --import public.txt
gpg --import master.key

git init test_repo
pushd test_repo

git config user.name 'Test User'
git config user.email 'test@testuser.com'

echo 'First Commit' >> README.md
git add . 
git commit -S -m "First Commit"

echo 'Second Commit' >> README.md
git add .
git commit -S -m "Second Commit"

echo 'Third Commit' >> README.md
git add .
git commit -S -m "Third Commit"

echo 'Fourth Commit' >> README.md
git add .
git commit -S -m "Fourth Commit"

echo 'Fifth Commit' >> README.md
git add .
git commit -S -m "Fifth Commit"

echo 'Sixth Commit' >> README.md
git add .
git commit -S -m "Sixth Commit"

popd 
