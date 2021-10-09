## Удаление локальных веток

git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d

## rebase

git checkout <branch>
git rebase master
<resolve conflicts>
git add .
git rebase --continue
git push --force

## git внутри

git cat-file -p <hash> - вернет описание хэш файла (blob/tree/commit)

# submodules
git submodule sync --recursive
git submodule update --init --recursive
git submodule update --remote
