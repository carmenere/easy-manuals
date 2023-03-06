```bash
DIR_1=foo/tests
DIR_2=bar/tests

cd ${DIR_1} && find . -type f -exec shasum {} + | sort -k 2 > /tmp/dir_1.txt && cd -
cd ${DIR_2} && find . -type f -exec shasum {} + | sort -k 2 > /tmp/dir_2.txt && cd -

diff /tmp/dir_1.txt /tmp/dir_2.txt
```