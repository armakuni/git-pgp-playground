#!/bin/bash

# Import the test GPG key and trust it
gpg --import public.t1.txt
gpg --import master.t1.key
gpg --import public.t2.txt
gpg --import master.t2.key
gpg --import public.t3.txt
gpg --import master.t3.key
gpg --import-ownertrust trustfile.txt 

# Set git author file for use in excersises
export GIT_DUET_AUTHORS_FILE=$PWD/.git-authors

# Create the test repo and set it's author data to match the test key
git init test_repo
pushd test_repo

# Create a signed git commit history
# Sleeps added to produce different timestamps 

git duet t1 t2
echo 'First Commit' >> README.md
git add . 
git duet-commit -S -m "First Commit"

sleep 1

git duet t2 t1
echo 'Second Commit' >> README.md
git add .
git duet-commit -S -m "Second Commit"

sleep 1 

git duet t1 t2
echo 'Third Commit' >> README.md
git add .
git duet-commit -S -m "Third Commit"

sleep 1

git duet t2 t1
echo 'Fourth Commit' >> README.md
git add .
git duet-commit -S -m "Fourth Commit"

sleep 1

git duet t1 t2
echo 'Fifth Commit' >> README.md
git add .
git duet-commit -S -m "Fifth Commit"

sleep 1

git duet t2 t1
echo 'Sixth Commit' >> README.md
git add .
git duet-commit -S -m "Sixth Commit"

# Return the user to the project root
popd 
