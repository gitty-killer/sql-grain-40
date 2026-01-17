#!/usr/bin/env python3
import argparse
import re
from collections import Counter

def read_text(path: str) -> str:
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

def tokenize(text: str) -> list[str]:
    return re.findall(r"[A-Za-z0-9]+", text.lower())

def compute_stats(text: str) -> tuple[int, int, int, Counter]:
    lines = text.count("\n") + (1 if text else 0)
    words = tokenize(text)
    counts = Counter(words)
    return lines, len(words), len(text), counts

def main() -> int:
    parser = argparse.ArgumentParser(description="Text statistics CLI")
    parser.add_argument("path", help="input text file")
    parser.add_argument("--top", type=int, default=10, help="top N words")
    args = parser.parse_args()

    text = read_text(args.path)
    lines, words, chars, counts = compute_stats(text)

    print(f"lines: {lines}")
    print(f"words: {words}")
    print(f"chars: {chars}")
    print("top words:")
    for word, count in sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[: args.top]:
        print(f"  {word}: {count}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
