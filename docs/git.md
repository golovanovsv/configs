## Удаление локальных веток

git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d

## rebase

git checkout <branch>
git rebase master
<resolve conflicts>
git add .
git rebase --continue
git push --force
