#!/bin/bash
set -ueE -o pipefail

# =====================================
# AUTOMATIC GITHUB ENVIRONMENT VARIABLES
# https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables

# GITHUB_REPOSITORY
# GITHUB_REF
# GITHUB_SHA

# =====================================
# MANUAL ENVIRONMENT VARIABLES

# SURGE_LOGIN
# SURGE_TOKEN
# SURGE_PROJECT

# =====================================
# LOCAL ENVIRONMENT VARIABLES

REPO_TAG=""
REPO_BRANCH=""
REPO_COMMIT=""
if [[ "$GITHUB_REF" == "refs/tags/"* ]]; then
	REPO_TAG="${GITHUB_REF#"refs/tags/"}"
elif [[ "$GITHUB_REF" == "refs/heads/"* ]]; then
	REPO_BRANCH="${GITHUB_REF#"refs/heads/"}"
	REPO_COMMIT="$GITHUB_SHA"
else
	echo "unknown GITHUB_REF=$GITHUB_REF"
	exit 1
fi

# org/name => name.org
SURGE_SLUG="$(echo "$GITHUB_REPOSITORY" | sed 's/^\(.*\)\/\(.*\)/\2.\1/')"

# defaults
if test -z "${SURGE_PROJECT-}"; then
	SURGE_PROJECT="."
fi

# =====================================
# CHECKS

if [[ "$REPO_BRANCH" = *"dependabot"* ]]; then
	echo "skipping as running on a dependabot branch"
	exit 0
elif test -z "${SURGE_LOGIN-}" -o -z "${SURGE_TOKEN-}"; then
	echo "you must provide a SURGE_LOGIN + SURGE_TOKEN combination"
	exit 1
fi

# =====================================
# RUN

targets=()

if test -n "$REPO_BRANCH"; then
	targets+=("$REPO_BRANCH.$SURGE_SLUG.surge.sh")
fi
if test -n "$REPO_TAG"; then
	targets+=("$REPO_TAG.$SURGE_SLUG.surge.sh")
fi
if test "$REPO_COMMIT"; then
	targets+=("$REPO_COMMIT.$SURGE_SLUG.surge.sh")
fi

if test ${#targets[@]} -eq 0; then
	echo 'failed to detect targets'
	exit 1
else
	for target in ${targets[*]}; do
		echo "deploying $SURGE_PROJECT to $target"
		npx --yes surge --project $SURGE_PROJECT --domain "$target"
	done
fi
