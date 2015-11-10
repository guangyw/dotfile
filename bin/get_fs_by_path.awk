#!/usr/bin/awk
BEGIN{
    split(ENVIRON["PATH_ARG"], path, "/");
    max_score = -1;
    result = "";
}
{
    split($2, cur, "/");
    score = 0
    for(dir in cur)
    {
        if(cur[dir] == "") continue;
        for(score ++; score <= length(path) && path[score] == ""; score ++);
        if(path[score] != cur[dir])
        {
            score = -1;
            break; 
        }
    }
    if(score > max_score)
    {
        max_score = score;
        result = $1
    }
}
END{
    for(i = max_score + 1; i <= length(path); i ++)
    {
        for(; i <= length(path) && path[i] == ""; i ++);
        result = result"/"path[i]
    }
    print result
}
