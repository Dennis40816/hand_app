"""
給 chatgpt 的提示詞:
接下來我將傳入最新版本的程式，格式的開頭是路徑以 ## related_path ## 包裹，剩下的則是程式，程式結束會添加一行 "======================="。 
請你加入英文 comment，順便更新你目前的程式，避免未來要加入新功能時出現錯誤。要盡可能清楚扼要。讓我們開始吧。
"""

"""
python .\tools\scripts\copy_content.py -i .\tools\scripts\input_files.txt -f  
"""
import os
import argparse
from pathlib import Path

'''
Usage: This Python script is designed to quickly consolidate specified programs for ChatGPT.
Input: 
    - default: Provide relative paths relative to APP_DIR (multiple files separated by spaces)
    - f --file: Output to the specified file as well (default name is output.txt)
    - i --input-file: Read specific designated file, each line is a relative path
Output: Systematic results will appear in the terminal

Example:
python copy_content.py data/file1.txt data/file2.txt more_data/another_file.txt
python copy_content.py data/file1.txt data/file2.txt more_data/another_file.txt -f output.txt
python copy_content.py -i /project/input_files/paths.txt
python copy_content.py -i /project/input_files/paths.txt -f output.txt
python copy_content.py -i /project/input_files/paths.txt -f # will output to output.txt
'''
# Define APP_DIR as the ../../ path relative to the script file location
APP_DIR = Path(__file__).resolve().parent.parent.parent
print(' ')
## debug
#print(APP_DIR)

def copy_and_print_content(relative_paths, output_file=None):
    output_lines = []

    for relative_path in relative_paths:
        abs_path = APP_DIR / relative_path
        if not abs_path.exists():
            output_lines.append(f"## {relative_path} ##")
            output_lines.append("Path does not exist.")
            output_lines.append("===================")
            continue

        output_lines.append(f"## {relative_path} ##")
        if abs_path.is_dir():
            for root, dirs, files in os.walk(abs_path):
                for name in files:
                    file_path = os.path.join(root, name)
                    with open(file_path, "r", encoding="utf-8") as file:
                        output_lines.append(file.read())
        elif abs_path.is_file():
            with open(abs_path, "r", encoding="utf-8") as file:
                output_lines.append(file.read())
        output_lines.append("===================")

    if output_file:
        with open(output_file, "w", encoding="utf-8") as f:
            f.write("\n".join(output_lines))

    for line in output_lines:
        print(line)

def read_paths_from_file(input_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        paths = [line.strip() for line in f if line.strip() and not line.startswith('#')]
    return paths

def main():
    parser = argparse.ArgumentParser(description="Process some relative paths.")
    parser.add_argument(
        "paths", metavar="P", type=str, nargs="*", help="relative paths to process"
    )
    parser.add_argument("-f", "--file", type=str, nargs="?", const="output.txt", help="output to file (default: output.txt)")
    parser.add_argument("-i", "--input-file", type=str, help="read paths from a file")

    args = parser.parse_args()

    if args.input_file:
        paths = read_paths_from_file(args.input_file)
    else:
        paths = args.paths

    output_file = args.file if args.file else "output.txt"
    if output_file and not output_file.endswith(".txt"):
        output_file += ".txt"

    copy_and_print_content(paths, output_file)

if __name__ == "__main__":
    main()