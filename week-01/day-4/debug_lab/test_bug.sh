#!/bin/bash
# usage: bash test_bug.sh save_day.sh

script=$(realpath "${1:-save_day.sh}")
fail=0

check() {
  if eval "$2"; then
    echo "PASS: $1"
  else
    echo "FAIL: $1"
    fail=$((fail+1))
  fi
}

# playground: temp folder with a fake remote
tmp=$(mktemp -d)
cd "$tmp"
git init -q --bare -b main remote.git
git clone -q remote.git work 2>/dev/null
cd work
git config user.email t@t.t
git config user.name tester
git checkout -q -B main

# fake files, including a secret
echo "SECRET=1" > .env
mkdir .venv
echo x > .venv/f
echo hi > a.txt

# variables the script needs
export msg="feat(week-01): add card" week=01 day=4

# run the script
out=$(bash "$script" 2>&1)
code=$?

check "gitignore lines have no leading space" '! grep -q "^ " .gitignore 2>/dev/null && [ -f .gitignore ]'
check ".env is not tracked by git" '! git ls-files | grep -qx ".env"'
check "commit message is the full message" '[ "$(git log -1 --format=%s 2>/dev/null)" = "$msg" ]'
check "push reached remote main" 'git --git-dir=../remote.git rev-parse -q --verify refs/heads/main >/dev/null'
check "prints saved only if everything worked" '! { echo "$out" | grep -q saved && ! git --git-dir=../remote.git rev-parse -q --verify refs/heads/main >/dev/null; }'

echo "exit code of script: $code"
echo "FAIL count: $fail"
exit $fail