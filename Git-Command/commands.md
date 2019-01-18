# git log grep (multiple keywords, format output)
repo forall -pc git log --grep="Secureboot\|VerifiedBoot" --author="minami.kazuma" --date=iso --│
pretty=format:"%x09%s%x09%H%x09%ad%x09%ae%x09%cd%x09%ce" > ~/samba/SecureBootCommits.csv 

# show modified file only
git show <hash> --name-only

# patch
git format-patch -<relate commit number> <commit hash> -o <out folder>

# patching
git am <.patch>

※ if conflict
git apply --reject <.patch> / .git/rebase-apply/patch
git add <modified files>
rm <.rej>
git am --resolved

※ patch - am は、コミットメッセージをそのまま移行してくれる

# diff patch
git diff <commit> <commit> > <.patch>
or
git format-patch ....

git apply
git add
git commit

※ apply は、修正内容のみ応用（コミットメッセージはなし）

# git log filter
git log -S ""

# change commit message
## just change most recently one
git commit --amend -m "new commit message"

## change particular one
git rebase -i <hash which at least one commit before the one that you want to commit>
(edit mode text will be shown)
change to "edit" at you-want-fix-commit-hash
ctrl-x -> y
(edit mode text will be closed)
git commit --amend -m "new commit message"
git rebase --continue

# git log show detail
git log -p

# show git branch remote link status
git branch -vv

# git push from local branch to remote branch (different branch)
git push origin local:remote

# git push with tracking
git push -u origin test

# git start tracking
git branch --set-upsteam-to=branch

# git stop tracking
git branch --stop-upsteam

# git diff only added file
git diff --cached
or
git diff --staged

# remove untraced files
git clean
(clean need force, use -f)
## check what will do (not execute)
git clean -n
## current untraced file
git clean -f
## target file
git clean -f <PATH>
## directory
git clean -df

# stash content show
git stash show -p stash@{N}
## even make patch
git stash show -p stash@{N} > xxx.patch

# show current tag
git describe --tags --abbrev=0
