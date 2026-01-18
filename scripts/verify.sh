#!/usr/bin/env bash
set -euo pipefail

path="data/sample.txt"
if [[ ! -f "$path" ]]; then
  echo "missing sample data" >&2
  exit 1
fi

run_and_check() {
  local output
  output="$($@)"
  echo "$output" | grep -q "^lines:" || { echo "missing lines"; exit 1; }
  echo "$output" | grep -q "^words:" || { echo "missing words"; exit 1; }
  echo "$output" | grep -q "^chars:" || { echo "missing chars"; exit 1; }
  echo "$output" | grep -q "^top words:" || { echo "missing top words"; exit 1; }
  echo "ok"
}

if [[ -f main.py ]]; then
  run_and_check python main.py "$path" --top 5
  exit 0
fi
if [[ -f textstats.py ]]; then
  run_and_check python textstats.py "$path" --top 5
  exit 0
fi
if [[ -f index.js ]]; then
  run_and_check node index.js "$path" --top 5
  exit 0
fi
if [[ -f index.ts ]]; then
  if [[ -f package.json ]]; then
    npm install --no-audit --no-fund
    run_and_check npx ts-node index.ts "$path" --top 5
  else
    echo "missing package.json for ts" >&2
    exit 1
  fi
  exit 0
fi
if [[ -f main.go ]]; then
  run_and_check go run main.go "$path" --top 5
  exit 0
fi
if [[ -f main.rs ]]; then
  rustc main.rs -o textstats
  run_and_check ./textstats "$path" --top 5
  exit 0
fi
if [[ -f TextStats.java ]]; then
  javac TextStats.java
  run_and_check java TextStats "$path" --top 5
  exit 0
fi
if [[ -f Program.cs ]]; then
  if [[ -f TextStats.csproj ]]; then
    run_and_check dotnet run --project TextStats.csproj -- "$path" --top 5
  else
    echo "missing TextStats.csproj" >&2
    exit 1
  fi
  exit 0
fi
if [[ -f main.c ]]; then
  cc main.c -o textstats
  run_and_check ./textstats "$path" --top 5
  exit 0
fi
if [[ -f main.cpp ]]; then
  c++ main.cpp -o textstats
  run_and_check ./textstats "$path" --top 5
  exit 0
fi
if [[ -f main.rb ]]; then
  run_and_check ruby main.rb "$path" --top 5
  exit 0
fi
if [[ -f index.php ]]; then
  run_and_check php index.php "$path" --top 5
  exit 0
fi
if [[ -f Main.kt ]]; then
  if ! command -v kotlinc >/dev/null 2>&1; then
    echo "kotlinc not found; skipping" >&2
    exit 0
  fi
  kotlinc Main.kt -include-runtime -d textstats.jar
  run_and_check java -jar textstats.jar "$path" --top 5
  exit 0
fi
if [[ -f main.swift ]]; then
  if ! command -v swift >/dev/null 2>&1; then
    echo "swift not found; skipping" >&2
    exit 0
  fi
  run_and_check swift main.swift "$path" --top 5
  exit 0
fi
if [[ -f Main.scala ]]; then
  if ! command -v scala >/dev/null 2>&1; then
    echo "scala not found; skipping" >&2
    exit 0
  fi
  run_and_check scala Main.scala "$path" --top 5
  exit 0
fi
if [[ -f main.lua ]]; then
  if ! command -v lua >/dev/null 2>&1; then
    echo "lua not found; skipping" >&2
    exit 0
  fi
  run_and_check lua main.lua "$path" --top 5
  exit 0
fi
if [[ -f main.sh ]]; then
  run_and_check bash main.sh "$path" --top 5
  exit 0
fi
if [[ -f main.ps1 ]]; then
  if command -v pwsh >/dev/null 2>&1; then
    run_and_check pwsh -File main.ps1 -Path "$path" -Top 5
    exit 0
  fi
  echo "pwsh not found; skipping" >&2
  exit 0
fi
if [[ -f index.html ]]; then
  grep -q "TextStats" index.html
  grep -q "computeStats" app.js
  echo "ok"
  exit 0
fi

echo "no known entrypoint" >&2
exit 1
