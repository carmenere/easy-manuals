# JQL
## Syntax
- `AND status in ('New', 'In Progress', 'Ready for test', 'Done')` finds issues by **status**;
- `AND issuetype IN ('Epic', 'Task', 'Bug')` finds **issues** by their type;
- `AND issueFunction IN subtasksOf("issuetype = Task")` finds **subtasks**;
- `AND (issuetype IN ('Epic', 'Task') OR issueFunction IN subtasksOf("issuetype = Task"))` finds **subtasks** OR finds **issues** by their type;
- `AND assignee was in ()` finds issues **ever assigned** to a user;
- `AND assignee in ()` finds issues **currently assigned** to a user;
- `AND fixVersion IN ()` finds issues by **version**;
- `AND fixVersion = EMPTY` finds issues by **version** if it is `None`;
- `ORDER BY`:
  - `ORDER BY status ASC, assignee ASC, summary ASC`;
  - `ORDER BY updatedDate ASC, created DESC`;

<br>

## Queries
### Tasks
```sql
project = CSPL
    AND (issuetype IN ('Epic', 'Task') OR issueFunction IN subtasksOf("issuetype = Task"))
    AND status in ('New', 'In Progress')
    AND assignee in (foo, bar)
    AND fixVersion IN ('0.1', '0.2')
    ORDER BY status ASC, assignee ASC, summary ASC
```

<br>

### Bugs
```sql
project = CSPL
    AND issuetype IN ('Bug')
    AND assignee in (foo, bar)
    AND fixVersion IN ('0.1', '0.2')
    ORDER BY status ASC, assignee ASC, summary ASC
```

<br>

### Find issues ever assigned to a user
```sql
project = CSPL
    AND issuetype IN ('Epic', 'Task')
    AND status in ('Ready for test', 'Done')
    AND assignee was in (foo, bar)
    ORDER BY updatedDate DESC
```
