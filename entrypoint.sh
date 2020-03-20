#!/usr/bin/env bash

if [ -n "${GITHUB_WORKSPACE}" ]; then
    cd "${GITHUB_WORKSPACE}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

exit_code=0

FILES=$(find "$INPUT_PATH_TO_SCHEMAS" -type f)

for f in $FILES; do
    ajv compile -s "$f" -m /iglu_meta_schema.json | reviewdog -f=checkstyle -name="iglulint" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}"

    echo $?
    RC=(${PIPESTATUS[@]})
    ec=$?
    echo ${RC[0]} ${RC[1]} $ec
    if [ ${ec} -ne 0 ]; then
        exit_code=${ec}
    fi
done

echo $exit_code
exit $exit_code
