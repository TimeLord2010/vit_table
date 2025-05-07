#!/usr/bin/env python3
import os
import sys
import argparse
import fnmatch
import json

# Load configuration from config.json (located in the same folder as this script)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CONFIG_FILE = os.path.join(BASE_DIR, "config.json")

DEFAULT_IGNORED_DIRS = []
DEFAULT_IGNORED_FILES = []
ADDITIONAL_IGNORED_DIRS = []
ADDITIONAL_IGNORED_FILES = []
# Removed INCLUDE_PATTERNS since generic inclusion is no longer used.
INCLUDE_FILE_PATTERNS = []
INCLUDE_FOLDER_PATTERNS = []
INCLUDE_CONTENT_PATTERNS = []

if os.path.exists(CONFIG_FILE):
    try:
        with open(CONFIG_FILE, "r", encoding="utf-8") as cfg:
            config = json.load(cfg)
            DEFAULT_IGNORED_DIRS = config.get("DEFAULT_IGNORED_DIRS", [])
            DEFAULT_IGNORED_FILES = config.get("DEFAULT_IGNORED_FILES", [])
            ADDITIONAL_IGNORED_DIRS = config.get("ADDITIONAL_IGNORED_DIRS", [])
            ADDITIONAL_IGNORED_FILES = config.get("ADDITIONAL_IGNORED_FILES", [])
            # Removed loading of generic inclusion patterns.
            INCLUDE_FILE_PATTERNS = config.get("INCLUDE_FILE_PATTERNS", [])
            INCLUDE_FOLDER_PATTERNS = config.get("INCLUDE_FOLDER_PATTERNS", [])
            INCLUDE_CONTENT_PATTERNS = config.get("INCLUDE_CONTENT_PATTERNS", [])
    except Exception as e:
        print(f"Failed to load configuration from {CONFIG_FILE}: {e}", file=sys.stderr)
        sys.exit(1)
else:
    print(f"Configuration file {CONFIG_FILE} not found.", file=sys.stderr)
    sys.exit(1)

def should_include(filepath, file_patterns, folder_patterns, content_patterns, verbose=False):
    """
    Determines if a file should be included based on filters in the following order:
      1. Folder Filter: Evaluates if any folder in the file's path (obtained via os.path.dirname) 
         matches a folder pattern.
      2. File Name Filter: Evaluates if the file's basename matches one of the file name patterns.
      3. Content Filter: Evaluates if the file content contains at least one of the specified substrings.
    """
    # 1. Folder name filter
    if folder_patterns:
        folder_path = os.path.dirname(filepath)
        folder_names = folder_path.split(os.sep)
        if not any(any(fnmatch.fnmatch(folder, pat) for pat in folder_patterns) for folder in folder_names):
            if verbose:
                print(f"Ignoring {filepath}: folder does not match folder patterns")
            return False

    # 2. File name filter
    if file_patterns:
        if not any(fnmatch.fnmatch(os.path.basename(filepath), pat) for pat in file_patterns):
            if verbose:
                print(f"Ignoring {filepath}: file name does not match file patterns")
            return False

    # 3. Content filter
    if content_patterns:
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            if not any(pattern in content for pattern in content_patterns):
                if verbose:
                    print(f"Ignoring {filepath}: content does not match content patterns")
                return False
        except Exception as e:
            if verbose:
                print(f"Could not read {filepath} for content filtering: {e}")
            return False

    return True

def collect_file_content(directory, ignore_dirs, ignore_files,
                         file_patterns, folder_patterns, content_patterns,
                         verbose=False, included_files=None):
    """
    Recursively reads the directory (or file) and collects content from files that pass all filters.
    Accumulates the absolute paths of included files in the 'included_files' list.
    """
    if included_files is None:
        included_files = []
    content = ""
    
    if os.path.isfile(directory):
        filename = os.path.basename(directory)
        if filename in ignore_files:
            if verbose:
                print(f"Ignoring file (default): {directory}")
            return content, included_files
        if not should_include(directory, file_patterns, folder_patterns, content_patterns, verbose):
            if verbose:
                print(f"Ignoring file (inclusion filters): {directory}")
            return content, included_files
        try:
            with open(directory, 'r', encoding='utf-8') as file_obj:
                if verbose:
                    print(f"Reading file: {directory}")
                content += f"\n--- {directory}:START ---\n"
                content += file_obj.read()
                content += f"\n--- {directory}:END ---\n"
            included_files.append(os.path.abspath(directory))
        except Exception as e:
            print(f"Could not read file {directory}: {e}", file=sys.stderr)
        return content, included_files

    for root, dirs, files in os.walk(directory):
        dirs[:] = [d for d in dirs if d not in ignore_dirs]
        files = [f for f in files if f not in ignore_files]

        for filename in files:
            filepath = os.path.join(root, filename)
            if not should_include(filepath, file_patterns, folder_patterns, content_patterns, verbose):
                continue
            try:
                with open(filepath, 'r', encoding='utf-8') as file_obj:
                    if verbose:
                        print(f"Reading file: {filepath}")
                    content += f"\n--- {filepath}:START ---\n"
                    content += file_obj.read()
                    content += f"\n--- {filepath}:END ---\n"
                included_files.append(os.path.abspath(filepath))
            except Exception as e:
                print(f"Could not read file {filepath}: {e}", file=sys.stderr)
    return content, included_files

def directory_has_included(current_dir, overall_root, included_rel_set):
    """
    Returns True if at least one file in the directory (recursively) has its relative path in included_rel_set.
    """
    for root, _, files in os.walk(current_dir):
        for f in files:
            rel_path = os.path.relpath(os.path.join(root, f), overall_root)
            if rel_path in included_rel_set:
                return True
    return False

def build_full_tree(current_dir, overall_root, included_rel_set, ignore_dirs, ignore_files):
    """
    Builds a full tree of the directory structure (excluding globally ignored items).
    - For directories: if none of its descendant files (at any level) is included (i.e. its relative path is not in included_rel_set),
      the directory name is suffixed with " (ignored)" and its subtree is not expanded.
    - For files: if the file's relative path is in included_rel_set, it is highlighted by surrounding its name with ">>> " and " <<<";
      otherwise, it is suffixed with " (ignored)".
    """
    tree = {}
    try:
        items = sorted(os.listdir(current_dir))
    except PermissionError:
        return tree

    for item in items:
        full_path = os.path.join(current_dir, item)
        rel_path = os.path.relpath(full_path, overall_root)
        if os.path.isdir(full_path):
            if item in ignore_dirs:
                continue
            if not directory_has_included(full_path, overall_root, included_rel_set):
                tree[item + " (ignored)"] = {}
            else:
                subtree = build_full_tree(full_path, overall_root, included_rel_set, ignore_dirs, ignore_files)
                tree[item] = subtree
        else:
            if item in ignore_files:
                continue
            if rel_path in included_rel_set:
                tree[">>> " + item + " <<<"] = None
            else:
                tree[item + " (ignored)"] = None
    return tree

def print_tree(tree, prefix=""):
    """
    Recursively converts the tree dictionary into a formatted string.
    """
    result = ""
    items = list(tree.items())
    for index, (name, subtree) in enumerate(items):
        connector = "├── " if index < len(items) - 1 else "└── "
        result += prefix + connector + name + "\n"
        if subtree is not None:
            extension = "│   " if index < len(items) - 1 else "    "
            result += print_tree(subtree, prefix + extension)
    return result

def main():
    parser = argparse.ArgumentParser(description="Collect file content and generate a directory tree.")
    parser.add_argument("directory", help="File or directory to process.")
    parser.add_argument("--ignore-dir", action="append", default=[],
                        help="Additional directories to ignore beyond those in config.json.")
    parser.add_argument("--ignore-file", action="append", default=[],
                        help="Additional files to ignore beyond those in config.json.")
    # Removed the --include parameter for generic inclusion.
    parser.add_argument("--include-file", action="append", default=[],
                        help="Inclusion patterns based on file name.")
    parser.add_argument("--include-folder", action="append", default=[],
                        help="Inclusion patterns based on folder name.")
    parser.add_argument("--include-content", action="append", default=[],
                        help="Inclusion patterns based on file content.")
    parser.add_argument("--no-defaults", action="store_true",
                        help="Do not use patterns from config.json; use only command-line parameters.")
    parser.add_argument("--output", default="output_coleta.txt",
                        help="Output file name (default: output_coleta.txt).")
    parser.add_argument("--verbose", action="store_true",
                        help="Enable verbose mode for debugging.")
    # Novo argumento para somente output da árvore
    parser.add_argument("--only-tree", action="store_true",
                        help="Output only the directory tree, without file contents.")

    args = parser.parse_args()

    if args.no_defaults:
        final_ignore_dirs = set(args.ignore_dir)
        final_ignore_files = set(args.ignore_file)
        final_include_file = list(args.include_file)
        final_include_folder = list(args.include_folder)
        final_include_content = list(args.include_content)
    else:
        final_ignore_dirs = set(DEFAULT_IGNORED_DIRS + ADDITIONAL_IGNORED_DIRS).union(args.ignore_dir)
        final_ignore_files = set(DEFAULT_IGNORED_FILES + ADDITIONAL_IGNORED_FILES).union(args.ignore_file)
        final_include_file = list(INCLUDE_FILE_PATTERNS) + args.include_file
        final_include_folder = list(INCLUDE_FOLDER_PATTERNS) + args.include_folder
        final_include_content = list(INCLUDE_CONTENT_PATTERNS) + args.include_content

    if not (os.path.isdir(args.directory) or os.path.isfile(args.directory)):
        print(f"Error: {args.directory} is not a valid file/directory or does not exist.", file=sys.stderr)
        sys.exit(1)

    # Collect file content and accumulate the list of included files (absolute paths)
    content, included_files = collect_file_content(
        directory=args.directory,
        ignore_dirs=final_ignore_dirs,
        ignore_files=final_ignore_files,
        file_patterns=final_include_file,
        folder_patterns=final_include_folder,
        content_patterns=final_include_content,
        verbose=args.verbose,
        included_files=[]
    )

    overall_root = os.path.abspath(args.directory)
    # Build a set of relative paths for the included files
    included_rel_set = {os.path.relpath(p, overall_root) for p in included_files}

    # Build the full tree using the directory structure and the set of included file relative paths
    full_tree = build_full_tree(overall_root, overall_root, included_rel_set, final_ignore_dirs, final_ignore_files)
    root_name = os.path.basename(overall_root)
    tree_str = root_name + "\n" + print_tree(full_tree)

    with open(args.output, "w", encoding="utf-8") as f:
        if args.only_tree:
            f.write(tree_str)
        else:
            f.write(content)
            f.write("\n\n--- Directory Tree ---\n\n")
            f.write(tree_str)

    print(f"Collection complete. Output saved to '{args.output}'.")

if __name__ == '__main__':
    main()
