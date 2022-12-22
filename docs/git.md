## Удаление локальных веток

git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d

## Edit last commit
git commit --amend -m "Updated message for the previous commit"
git commit --amend --no-edit

## Revert one commit
git revert [--edit] <commit>
--edit - edit commit message

## Delete branch
git branch -d <branch-name>
git branch -d -r origin/<remote branch-name>

## rebase
git checkout <branch>
git rebase master
<resolve conflicts>
git add .
git rebase --continue
git push --force

git rebase --ineractive HEAD~1
r - отредактировать commit-massage


# changes in merge
git merge --no-commit origin/FFMSK-666666
<edit readme.md>
git add docs/readme.md
git commit

## cherry-pick
git cherry-pick <commit-sha> - поместит коммит в текущий HEAD

## git внутри

git cat-file -p <hash> - вернет описание хэш файла (blob/tree/commit)

# submodules
git submodule sync --recursive
git submodule update --init --recursive
git submodule update --remote

# remove submodules
Run git rm --cached path_to_submodule (no trailing slash).
Delete the relevant line from the .gitmodules file.
Delete the relevant section from .git/config.
Commit and delete the now untracked submodule files.

# Config
git config --global "http.https://gitlab.int".sslVerify false
git config --global "http.https://gitlab.int".sslCAInfo /etc/ssl/ca.pem 
