#!/usr/bin/env python3
"""
Convert Jekyll-formatted .md lessons to basic .Rmd files for RStudio

Minimal conversion:
1. Add YAML frontmatter
2. Remove Jekyll syntax: {: .language-r}, {: .bash}, etc.
3. Fix image links: {{ page.root }}/fig/ → ../fig/
4. Convert ~~~ to ``` (standard markdown code blocks)
5. Keep code as quoted blocks (user decides on chunks later)
"""

import re
import sys
from pathlib import Path


def convert_md_to_rmd(input_file, output_file=None):
    """Convert a single .md file to .Rmd"""

    input_path = Path(input_file)
    if not input_path.exists():
        print(f"Error: File not found: {input_file}")
        return False

    # Default output: same name with .Rmd extension
    if output_file is None:
        output_path = input_path.with_suffix('.Rmd')
    else:
        output_path = Path(output_file)

    print(f"Converting: {input_path} → {output_path}")

    # Read input
    with open(input_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract title from first # heading (if exists)
    title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
    title = title_match.group(1) if title_match else input_path.stem

    # Build YAML frontmatter
    yaml_header = f"""---
title: "{title}"
output: html_document
---

"""

    # 1. Remove Jekyll liquid tags ({{ page.root }}, etc.)
    content = re.sub(r'\{\{\s*page\.root\s*\}\}', '..', content)

    # 2. Remove Jekyll code block annotations
    # {: .language-r} → (remove)
    # {: .bash} → (remove)
    # {: .output} → (remove)
    content = re.sub(r'\{:\s*\.[\w-]+\s*\}', '', content)

    # 3. Convert ~~~ to ``` (standard markdown)
    content = re.sub(r'^~~~\s*$', '```', content, flags=re.MULTILINE)

    # 4. Fix image references
    # <a href="{{ page.root }}/fig/..."> → <a href="../fig/...">
    # <img src="{{ page.root }}/fig/..."> → <img src="../fig/...">
    content = re.sub(
        r'(href|src)="\{\{\s*page\.root\s*\}\}/',
        r'\1="../',
        content
    )

    # 5. Remove common Jekyll-specific syntax
    # {% include ... %} → (remove entire line)
    content = re.sub(r'\{%.*?%\}', '', content)

    # 6. Clean up excessive blank lines (more than 2 → 2)
    content = re.sub(r'\n{3,}', '\n\n', content)

    # 7. Add YAML header
    final_content = yaml_header + content

    # Write output
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(final_content)

    print(f"✅ Created: {output_path}")
    return True


def convert_all_lessons(lessons_dir='lessons', pattern='*.md'):
    """Convert all .md files in lessons directory"""

    lessons_path = Path(lessons_dir)
    if not lessons_path.exists():
        print(f"Error: Directory not found: {lessons_dir}")
        return

    md_files = sorted(lessons_path.glob(pattern))

    if not md_files:
        print(f"No .md files found in {lessons_dir}")
        return

    print(f"Found {len(md_files)} lesson files")
    print("=" * 60)

    success_count = 0
    for md_file in md_files:
        if convert_md_to_rmd(md_file):
            success_count += 1
        print()

    print("=" * 60)
    print(f"✅ Converted {success_count}/{len(md_files)} files")
    print()
    print("Next steps:")
    print("1. Review the .Rmd files in RStudio")
    print("2. Convert code blocks to R chunks where appropriate:")
    print("   Change: ```")
    print("           code here")
    print("           ```")
    print("   To:     ```{r}")
    print("           code here")
    print("           ```")
    print("3. Test rendering with 'Knit' button in RStudio")


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description='Convert Jekyll .md lessons to .Rmd for RStudio'
    )
    parser.add_argument(
        'input',
        nargs='?',
        help='Input .md file (or directory for batch conversion)'
    )
    parser.add_argument(
        '-o', '--output',
        help='Output .Rmd file (only for single file conversion)'
    )
    parser.add_argument(
        '-d', '--directory',
        default='lessons',
        help='Directory containing lessons (default: lessons/)'
    )
    parser.add_argument(
        '-a', '--all',
        action='store_true',
        help='Convert all .md files in lessons directory'
    )

    args = parser.parse_args()

    if args.all or (args.input and Path(args.input).is_dir()):
        # Batch conversion
        directory = args.input if args.input else args.directory
        convert_all_lessons(directory)
    elif args.input:
        # Single file conversion
        convert_md_to_rmd(args.input, args.output)
    else:
        # Default: convert all in lessons/
        print("No input specified, converting all files in lessons/")
        print()
        convert_all_lessons(args.directory)


if __name__ == '__main__':
    main()
