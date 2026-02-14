#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

error_count=0
name_cache_file="$(mktemp)"
trap 'rm -f "$name_cache_file"' EXIT

echo "检查 skills 目录..."

for skill_dir in skills/*; do
  if [[ ! -d "$skill_dir" ]]; then
    continue
  fi

  dir_name="$(basename "$skill_dir")"
  skill_file="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_file" ]]; then
    echo "✗ 缺少文件: $skill_file"
    error_count=$((error_count + 1))
    continue
  fi

  name_line="$(sed -n 's/^name:[[:space:]]*//p' "$skill_file" | head -n 1)"
  desc_line="$(sed -n 's/^description:[[:space:]]*//p' "$skill_file" | head -n 1)"

  if [[ -z "$name_line" ]]; then
    echo "✗ $skill_file 缺少 frontmatter 字段 name"
    error_count=$((error_count + 1))
  fi

  if [[ -z "$desc_line" ]]; then
    echo "✗ $skill_file 缺少 frontmatter 字段 description"
    error_count=$((error_count + 1))
  fi

  if [[ "$name_line" != "$dir_name" ]]; then
    echo "✗ name 与目录不一致: $skill_file (name=$name_line, dir=$dir_name)"
    error_count=$((error_count + 1))
  fi

  if [[ ! "$dir_name" =~ ^[a-z0-9-]+$ ]]; then
    echo "✗ 技能目录名不符合 kebab-case: $dir_name"
    error_count=$((error_count + 1))
  fi

  printf '%s\n' "$name_line" >> "$name_cache_file"
done

duplicate_names="$(sort "$name_cache_file" | uniq -d || true)"
if [[ -n "$duplicate_names" ]]; then
  echo "✗ 检测到重复 skill name:"
  echo "$duplicate_names" | sed 's/^/  - /'
  error_count=$((error_count + 1))
fi

if [[ -f ".claude-plugin/marketplace.json" ]]; then
  echo "检查 marketplace 引用..."
  if ! node <<'NODE'
const fs = require('fs');
const path = require('path');

const file = '.claude-plugin/marketplace.json';
const raw = fs.readFileSync(file, 'utf8');
const data = JSON.parse(raw);

if (!Array.isArray(data.plugins)) {
  throw new Error('plugins 字段必须是数组');
}

const missing = [];
for (const plugin of data.plugins) {
  if (!Array.isArray(plugin.skills)) continue;
  for (const skillPath of plugin.skills) {
    const absPath = path.resolve(skillPath);
    const skillFile = path.join(absPath, 'SKILL.md');
    if (!fs.existsSync(skillFile)) {
      missing.push(`${skillPath}/SKILL.md`);
    }
  }
}

if (missing.length) {
  console.error('缺少被 marketplace 引用的 skill 文件:');
  for (const item of missing) console.error(`  - ${item}`);
  process.exit(1);
}
NODE
  then
    error_count=$((error_count + 1))
  fi
fi

if [[ "$error_count" -gt 0 ]]; then
  echo
  echo "校验失败: $error_count 个问题"
  exit 1
fi

echo
echo "校验通过: skills 结构和 marketplace 引用正常"
