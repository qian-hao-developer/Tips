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

git apply

※ patch - am は、コミットメッセージなし