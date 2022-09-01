# Merge many branches ``SRC_BRANCH_i`` into branch ``DST_BRANCH``
## Prerequisites
```bash
SRC_BRANCH_1=dev_1
SRC_BRANCH_2=dev_2

DST_BRANCH=some_dst_branch

LOCAL_DST_BRANCH="merge_${SRC_BRANCH_1}_and_${SRC_BRANCH_2}_to_${DST_BRANCH}"
COMMIT_MSG_1="Merge branch 'origin/${SRC_BRANCH_1}' into 'origin/${DST_BRANCH}'"
COMMIT_MSG_2="Merge branch 'origin/${SRC_BRANCH_2}' into 'origin/${DST_BRANCH}'"

echo SRC_BRANCH_1=${SRC_BRANCH_1}
echo SRC_BRANCH_2=${SRC_BRANCH_2}
echo DST_BRANCH=${DST_BRANCH}
echo LOCAL_DST_BRANCH=${LOCAL_DST_BRANCH}
echo COMMIT_MSG_1=${COMMIT_MSG_1}
echo COMMIT_MSG_2=${COMMIT_MSG_2}
```

<br>

## Update all remote branches
```bash
git remote update
```

<br>

## Checkout to ``LOCAL_DST_BRANCH``
```bash
git checkout --no-track -b "${LOCAL_DST_BRANCH}" "origin/${DST_BRANCH}"
```

<br>

## Merge all ``SRC_BRANCH_i`` into ``LOCAL_DST_BRANCH``
```bash
git merge -m "${COMMIT_MSG_1}" "origin/${SRC_BRANCH_1}"
git merge -m "${COMMIT_MSG_2}" "origin/${SRC_BRANCH_2}"
```

<br>

## Push 
### Case 1. Just push
```bash
git push origin "${LOCAL_DST_BRANCH}":"${LOCAL_DST_BRANCH}"
```

### Case 2. With ``push options`` for GitLab
```bash
git push origin "${LOCAL_DST_BRANCH}":"${LOCAL_DST_BRANCH}" \
    -o merge_request.create \
    -o merge_request.target=${DST_BRANCH} \
    -o merge_request.title="SYNC: ${SRC_BRANCH_1} and ${SRC_BRANCH_2} => ${DST_BRANCH}" \
    -o merge_request.remove_source_branch \
    -o merge_request.merge_when_pipeline_succeeds
```

<br>

## Remove ``${LOCAL_DST_BRANCH}``
### Delete ``local branch`` with name ${LOCAL_DST_BRANCH}
```bash
git branch -D "${LOCAL_DST_BRANCH}"
```

### Delete ``upstream branch`` with name ${LOCAL_DST_BRANCH}
```bash
git push origin --delete "${LOCAL_DST_BRANCH}"
```

### Delete ``remote branch`` with name ${LOCAL_DST_BRANCH}
```bash
git branch --delete --remotes origin/"${LOCAL_DST_BRANCH}"
```

### Delete all stale ``remote branches``
```bash
git fetch --all --prune
```
