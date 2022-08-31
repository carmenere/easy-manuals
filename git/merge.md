# Merge one branch ``SRC_BRANCH`` into branch ``DST_BRANCH``
## Prerequisites
```bash
SRC_BRANCH=dev_1

DST_BRANCH=some_dst_branch

LOCAL_DST_BRANCH="merge_${SRC_BRANCH}_to_${DST_BRANCH}"
COMMIT_MSG="Merge branch 'origin/${SRC_BRANCH}' into 'origin/${DST_BRANCH}'"

echo SRC_BRANCH=${SRC_BRANCH}
echo DST_BRANCH=${DST_BRANCH}
echo LOCAL_DST_BRANCH=${LOCAL_DST_BRANCH}
echo COMMIT_MSG=${COMMIT_MSG}
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

## Merge ``SRC_BRANCH`` into ``LOCAL_DST_BRANCH``
```bash
git merge -m "${COMMIT_MSG}" "origin/${SRC_BRANCH}"
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
    -o merge_request.title="SYNC: ${SRC_BRANCH} => ${DST_BRANCH}" \
    -o merge_request.remove_source_branch \
    -o merge_request.merge_when_pipeline_succeeds
```

<br>

## Remove ``LOCAL_DST_BRANCH``
```bash
git branch -D "${LOCAL_DST_BRANCH}"
```
