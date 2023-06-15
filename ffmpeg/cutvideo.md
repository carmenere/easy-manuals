# Options
|Options|Description|
|:------|:----------|
|`-ss position`|Specifies the **start time**. Here `position` can be specified in `seconds` or in `hh:mm:ss[.xxx]` format.|
|`-t duration`|Specifies the **duration** of the clip. Here `duration` can be specified in `seconds` or in `hh:mm:ss[.xxx]` format. Instead of `-t`, you can also use `-to`, which specifies the **end time**.|
|`-i <path>`|Here `<path>` is **input** file name.|
|`-c copy <path>`|Here `<path>` is **output** file name.|
|`-y`|**Overwrite** output files.|

<br>

## Example 1
This script cuts movie into 2 parts, where `01:33:00` is a **middle** of original movie:
```bash
ffmpeg -t 01:33:00 -i ~/Downloads/Movie.mkv -c copy ~/Downloads/Movie-part1.mkv
ffmpeg -ss 01:33:00 -i ~/Downloads/Movie.mkv -c copy ~/Downloads/Movie-part2.mkv
```

<br>

## Example 2
This script cuts **particular** part from original movie:
```bash
ffmpeg -ss 01:00:00 -t 00:30:00 -i ~/Downloads/Movie-2.mkv -c copy ~/Downloads/Movie-2.3.mkv
```
