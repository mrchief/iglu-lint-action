#!/usr/bin/env bash

if [[ "$INPUT_LEVEL" == "info" ]]; then
    VERBOSE=' '
fi

prNum=$(cat ${GITHUB_EVENT_PATH} | jq --raw-output .pull_request.number)
commitId=$(cat ${GITHUB_EVENT_PATH} | jq --raw-output .after)
owner=$(cat ${GITHUB_EVENT_PATH} | jq --raw-output .repository.owner.login)
repo=$(cat ${GITHUB_EVENT_PATH} | jq --raw-output .repository.name)

allComments=$(curl -s "https://api.github.com/repos/${owner}/${repo}/pulls/${prNum}/comments" \
    -H 'Accept: application/vnd.github.comfort-fade-preview+json' \
    -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}")

info() {
    if [[ ! -z "$VERBOSE" ]]; then
        echo -e "\n>>>>>>>\n"
        echo $@
        echo -e "\n<<<<<<<\n"
    fi
}

removePreviousComments() {
    info "removing comments for: $1 $2"
    echo $allComments |
        jq --arg file "$1" --argjson line $2 '.[]
          | select(.user.login=="github-actions[bot]")
          | { id: .id, path: .path, line: .line }
          | select(.path==$file and .line==$line)
          | .id' |
        xargs -r -I {} curl -X DELETE "https://api.github.com/repos/${owner}/${repo}/pulls/comments/{}" \
            -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
            ${VERBOSE:--S} ${VERBOSE:+-v} -s
}

postJsonLintError() {
    msg=$1
    info "msg: ${msg}"

    if [[ ${msg} =~ (.+):\ line\ ([0-9]+),\ col\ ([0-9]+),\ (.*)$ ]]; then
        postComment "${BASH_REMATCH[1]}" "${BASH_REMATCH[4]}" "${BASH_REMATCH[2]}"
    fi
}

postIgluError() {
    f=$1
    igluErrors=$2

    errorBody="$(head -n -3 <<<$(tail -n +2 <<<${igluErrors}))"
    info "errorBody: ${errorBody}"
    regex='[0-9]\.\ error: "([^"]+)".*'
    if [[ $errorBody =~ $regex ]]; then
        # crude way of figuring our offending line
        line="$(awk -v pat="${BASH_REMATCH[1]}" '$0 ~ pat{ print NR; exit }' "${f}")"
        info "line: $line"
    fi
    postComment "${f}" "${errorBody}" $line
}

postComment() {
    # args: file, message, line
    local body
    body=$(jq -n \
        --arg bod "$2" \
        --arg cid "${commitId}" \
        --argjson line ${3:-1} \
        --arg path "$1" \
        '{body: $bod, commit_id: $cid, side: "RIGHT", line: $line, path: $path }')

    info "body: ${body}"

    removePreviousComments "$1" "$3"
    curl "https://api.github.com/repos/${owner}/${repo}/pulls/${prNum}/comments" \
        -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
        -H 'Content-Type: application/json' \
        -H 'Accept: application/vnd.github.comfort-fade-preview+json' \
        ${VERBOSE:--S} ${VERBOSE:+-v} -s \
        --data-raw "${body}"
}

FILES=$(find ${INPUT_PATH_TO_SCHEMAS} -type f)

jsonlintExitCode=0
iglulintExitCode=0

for f in $FILES; do
    lintErrors="$(jsonlint ${f} -c 2>&1 >/dev/null)"
    ec=$?
    if [ $ec -ne 0 ]; then
        jsonlintExitCode=$ec
        postJsonLintError "${lintErrors}"
    else
        igluErrors=$(igluctl lint --skip-checks description,rootObject,stringLength,optionalNull ${f})
        ec=$?
        if [ $ec -ne 0 ]; then
            iglulintExitCode=$ec
            postIgluError "${f}" "${igluErrors}"
        fi
    fi
done

if [ $jsonlintExitCode -ne 0 ]; then
    exit $jsonlintExitCode
fi
if [ $iglulintExitCode -ne 0 ]; then
    exit $iglulintExitCode
fi
