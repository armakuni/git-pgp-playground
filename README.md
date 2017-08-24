# Git PGP Playground

This repository is a playground provided to work through the concepts of the [Is your Pair Programming Git Commit 
Workflow Secure?]() blog post series on the Armakuni tech blog. 

It allows the user to play with some of the concepts of both git pgp signing and pgp signing while working 
in a pair with git-duet. 

When running the included script: 

1. **A number of PGP keys are added and trusted - you may want to remove them after this exersise**
1. A git-authors file is created
1. A git repo in the working directory is created called *test_repo*
1. A number of sample signed commits are made 

All keys have the super secure pass phrase *password* 

## Requirements

- [git-duet](https://github.com/git-duet/git-duet)
- [gpg-suite](https://gpgtools.org/)
- The latest version of [git](https://git-scm.com/). Later versions include many features for helping display the validity of PGP features

## Usage

Create the sample repo and use the bundled git authors file. Exit the current shell to stop using the bundled authors 
file. 

```bash
./make_test_repo.sh
GIT_DUET_AUTHORS_FILE=$PWD/.git-authors
```

### View The Newly Added Keys

The script adds some PGP keys to your key ring. 

```bash
gpg --list-keys

``` 

```
gpg: checking the trustdb
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
gpg: depth: 0  valid:   3  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 4u
/Users/yourname/.gnupg/pubring.gpg
----------------------------------
pub   4096R/4285E023 2017-08-23
uid       [ultimate] Test User <test@testuser.com>

pub   4096R/2F54E5A8 2017-08-23
uid       [ultimate] Test User Two <test2@testuser.com>

pub   4096R/82658402 2017-08-23
uid       [ultimate] Test User Three <test3@testuser.com>
```

### View The Demo Commit History

```bash
cd test_repo
```

View the signatures of the commits so far:

```bash
git log --show-signature
```

```
commit b1316b71f9548d3f3fc0f343e787950a769656ed (HEAD -> master)
gpg: Signature made Wed 23 Aug 14:28:22 2017 BST
gpg:                using RSA key A74343224285E023
gpg: Good signature from "Test User <test@testuser.com>" [ultimate]
Author: Test User Two <test2@testuser.com>
Date:   Wed Aug 23 14:28:22 2017 +0100

    Sixth Commit

    Signed-off-by: Test User <test@testuser.com>

commit 58fce0153761112e4043dedef45a1653c45333e3
gpg: Signature made Wed 23 Aug 14:28:20 2017 BST
gpg:                using RSA key 425BC4962F54E5A8
gpg: Good signature from "Test User Two <test2@testuser.com>" [ultimate]
Author: Test User <test@testuser.com>
Date:   Wed Aug 23 14:28:20 2017 +0100

    Fifth Commit

    Signed-off-by: Test User Two <test2@testuser.com>

commit ce04fa72bc2c5da081ef0403bf721fd068bc5d0b
gpg: Signature made Wed 23 Aug 14:28:19 2017 BST
gpg:                using RSA key A74343224285E023
gpg: Good signature from "Test User <test@testuser.com>" [ultimate]
Author: Test User Two <test2@testuser.com>
Date:   Wed Aug 23 14:28:19 2017 +0100

    Fourth Commit

    Signed-off-by: Test User <test@testuser.com>
    
    
... more commit history     
    
```

View condensed Good / Bad signature output: 

```bash 
git log --pretty=format:%G?
```

```
G
G
G
G
G
G
```

### Make A Signed Commit - Solo Developer

Select the test user using `git solo [INITAL]` and use the `duet-commit` sub command

```
echo 'Commit Seven' >> README.md
git add .
git solo t1
git duet-commit -S -m "Commit Seven"
git log --show-signature --pretty=format:%G?
```

```
gpg: Signature made Wed 23 Aug 15:19:53 2017 BST
gpg:                using RSA key A74343224285E023
gpg: Good signature from "Test User <test@testuser.com>" [ultimate]
G

... More Commits
```

### Make A Signed Commit - Pair Developer

Select a pair of test users using `git duet [INITAL] [INITAL]` and use the `duet-commit` sub command

```
echo 'Commit Eight' >> README.md
git add .
git duet t1 t2
git duet-commit -S -m "Commit Eight"
git log --show-signature
```

Note the author is set to 'Test User Two' while both the signed off by and gpg signatures are those of 'Test User'.

```
commit 2f8c76eb1ff310f34bcae2807dd93b6d8ecb54e5 (HEAD -> master)
gpg: Signature made Wed 23 Aug 15:22:17 2017 BST
gpg:                using RSA key A74343224285E023
gpg: Good signature from "Test User <test@testuser.com>" [ultimate]
Author: Test User Two <test2@testuser.com>
Date:   Wed Aug 23 15:22:17 2017 +0100

    Commit Eight

    Signed-off-by: Test User <test@testuser.com>
```

### Rebasing

In this example 'Test User Three' is making a change the revision history. For reasons known only to T3 they have 
decided to squash the previous commits into one. As this will invalidate signatures of the previous commits they must 
sign the change. Due to various reasons explained [here](https://github.com/git-duet/git-duet/pull/25) rebasing with 
git-duet is a little tricky.

Test User 3 solo's and then uses the `git rebase -i --exec` command to run a command top update the committer 
information. 

```
git rebase -i --exec 'git duet-commit --amend --reset-author -S' [COMMIT HASH]
```  

Rebase output, note we choose to squash commit 8 into commit 7 . 

```
pick 7fe6013 Commit Seven
exec git duet-commit --amend --reset-author -S
s 2f8c76e Commit Eight
exec git duet-commit --amend --reset-author -S

# Rebase b1316b7..2f8c76e onto b1316b7 (4 commands)
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

The output of git log shows that the author information and signature has been reset. There is some loss in audit trail 
here: 

1. We don't know who the original author of the change was
1. Although this is 'Signed-off-by' Test User, the signature supplied is that of Test User 3. 
1. However we do know for sure that the change was authorized by Test User 3, their PGP signature is supplied. 

To avoid this, don't re-write history that has been pushed to the remote. See the linked blog post above for details.   

```
git log --show-signature
```

```
commit adc44be2c766ea295929e1280c07d29e02fcd5f6 (HEAD -> master)
gpg: Signature made Wed 23 Aug 16:07:38 2017 BST
gpg:                using RSA key 36230E4982658402
gpg: Good signature from "Test User Three <test3@testuser.com>" [ultimate]
Author: Test User Three <test3@testuser.com>
Date:   Wed Aug 23 16:07:33 2017 +0100

    Commit Seven

    Signed-off-by: Test User <test@testuser.com>

    Commit Eight

    Signed-off-by: Test User <test@testuser.com>
```
