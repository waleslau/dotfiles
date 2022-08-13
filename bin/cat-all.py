#!/usr/bin/env python3
import os,sys, subprocess

IGNORE_DIRS=[".git",".vscode","build","node_modules"]
pwd=os.getcwd()

for  (dirpath, dirnames, filenames) in os.walk(pwd):
    if not any(ig in dirpath for ig in IGNORE_DIRS):
        for file in filenames:
            full_path=dirpath+"/"+file
            relative_path=full_path[len(pwd)+1:]

            mimetype=subprocess.check_output(["file","--dereference","--brief", "--mime-type", full_path]).decode()
            
            if(mimetype.startswith("text")):
                try:
                    with open(full_path,"r") as f:
                        for ln,line in enumerate(f,start=1):
                            if not line.isspace():
                                print(relative_path,"|",ln,"|",line.strip())
                except:
                    print("[FAILED] ",full_path, file=sys.stderr) 

'''
https://forum.suse.org.cn/t/topic/14557
require fd and fzf
'''
