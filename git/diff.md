# git diff
`git diff ref` shows changes between the **working tree** and the **index** by default, if `ref` is **omitted** `HEAD` is used..<br>
`git diff --cached ref` shows changes between the **index** and **commit** `ref`, if `ref` is **omitted** `HEAD` is used.<br>
`git diff ref1 ref2` shows **diff** between `ref1` and `ref2`.<br>
`git diff ref1 ref2 -- <path>` shows **diff** between `ref1` and `ref2` for specific file `<path>`.<br>
`git diff --name-only ref1 ref2` shows **only changed files** between `ref1` and `ref2`.
