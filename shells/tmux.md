# tmux
The **prefix** is the **combination of keys** you press **before** any **command**.<br>
**By default**, **prefix** is `Ctrl + B` or `C-b`, but it can be customized to be any combination.<br>

<br>

## Comamnds
|Command|Description|
|:-------|:----------|
|`tmux ls`|List of all tmux sessions.|
|`tmux new -s <name>`|**Create** new session `<name>` and **attach** to it.|
|`tmux a`|**Attach** to **last** created session.|
|`tmux a -t <name>`|**Attach** to session `<name>`.|
|`tmux kill-session -t <name>`|Close session `<name>`.|
|`tmux kill-server`|Close **all** sessions.|

<br>

## General
|Shortcut|Description|
|:-------|:----------|
|`C-b` then type `:rename-window <name>`|Rename current window.|
|`C-b` `d`|**Detach** from currently attached session.|
|`C-b` `c`|**New** window.|
|`C-b` `w`|**List** all windows.|
|`C-b` `x`|**Close** window or pane.|

<br>

## Navigation
|Shortcut|Description|
|:-------|:----------|
|`C-b` `n`|Move to **next** window.|
|`C-b` `p`|Move to **previous** window.|

<br>

## Panes
|Shortcut|Description|
|:-------|:----------|
|`C-b` `⇧` `"`|New **horizontal** pane.|
|`C-b` `⇧` `%`|New **vertical** pane.|
|`C-b` *arrows*|Switching between panes.|