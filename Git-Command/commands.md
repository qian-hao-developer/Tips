==================== log
# git log grep (multiple keywords, format output)
repo forall -pc git log --grep="Secureboot\|VerifiedBoot" --author="minami.kazuma" --date=iso --│
pretty=format:"%x09%s%x09%H%x09%ad%x09%ae%x09%cd%x09%ce" > ~/samba/SecureBootCommits.csv

# show modified file only
git show <hash> --name-only

# git log filter
git log -S ""

# git log show detail
git log -p

# git diff only added file
git diff --cached
or
git diff --staged

# list tag by commit time and get latest
git tag --sort=committerdate | tail -1


==================== add
# add part of changes
git add -p <file>
use s to split, y to stage, n to skip


==================== commit
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


==================== merge
#combine commit
git merge --squash <branch>

#forget previous resolution for conflict
git merge ...
(conflict happen)
git rerere forget <file_path>


==================== tag
# show current tag
git describe --tags --abbrev=0

# push all tags
git push <remote> --tags

# pull tags
git fetch --tags

# check remote tags
git ls-remote -t (remote)

# delete local tag
git tag -d <tag>

# delete remote tag
git push <remote> :<tag>

# tag filter
git tag -l "*tag*"


==================== patch
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


==================== stash
# stash content show
git stash show -p stash@{N}
## even make patch
git stash show -p stash@{N} > xxx.patch


==================== branch
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

# branch 分岐点
## use merge-base
git merge-base <b1> <b2>
## 共通コミット(３つブランチ内最も最近の共通コミット)
git merge-base <b1> <b2> <b3>
## use show-branch
git show-branch <b1> <b2> | tail -1
(一行目は分岐コミット)
git show-branch --merge-base <b1> <b2>
(分岐コミットのみ表示)
git show-branch --sha1-name <b1> <b2>
(ブランチ情報をハッシュ表示にする)


==================== clean
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


===================== others
# zip source with .gitignore
git archive <hash> --output=hoge.zip
## specific folder without folder self
git archive <hash>:folder --output=hoge.zip
## specific folder
git archive <hash> folder --output=hoge.zip

# list untracked files
git ls-files --others


===================== commands
# get remote address
git remote -v | sed -n '1p' | awk '{print $2}' | tr -d '\n' | xsel -bi
