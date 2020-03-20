#!/usr/bin/env bash

if [ -n "${GITHUB_WORKSPACE}" ]; then
    cd "${GITHUB_WORKSPACE}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

exit_code=0

for f in "$INPUT_PATH_TO_SCHEMAS"; do
    ajv compile -s "$f" -m /iglu_meta_schema.json |
        reviewdog -f=checkstyle -name="iglulint" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}"

    ec=$?
    if [ ${ec} -ne "0" ]; then
        exit_code=${ec}
    fi

done

exit $exit_code
