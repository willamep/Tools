#!/usr/bin/env python3
import shutil
from pathlib import Path

def get_extentions(source):
    suf = set()
    for file in source.iterdir():
        suf.add(file.suffix[1:])
    return suf

def filesort(P):
    source = P / "Sources"
    direction = P / "Sorted"
    print(f'{source}\t{direction}')
    return


P = Path('.')
# suf = get_extentions(P / 'Sources')


if __name__ == "__main__":
    filesort(P)
    # print(f'Source: {P}')
    # print(suf)
    
    # for extention in suf:
    #     (P / 'Sorted' / extention).mkdir(exist_ok=True, parents=True)
    
    # for file in (P / 'Sources').iterdir():
    #     # print(file)
    #     # print(Path(file))
    #     file.replace(P / 'Sorted' / file.name)