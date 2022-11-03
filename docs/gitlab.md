# rules.changes
changes принадлежат коммиту и наследуются от него ветками и тегами. Если назначить на коммит новый тег или ветку, то в их свойствах будут унаследованные changes.

# only one pipeline for MR
```
lint-template:
  rules:
    - if: $CI_COMMIT_BRANCH && $CI_OPEN_MERGE_REQUESTS == null
    - if: $CI_MERGE_REQUEST_TARGET_BRANCH_NAME
    - if: $CI_COMMIT_TAG
```
