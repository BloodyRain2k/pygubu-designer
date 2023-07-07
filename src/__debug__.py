import sys, logging
# sys.path.insert(1, __file__)
sys.path.insert(1, "D:\Coding\- My -\Python\PyGubu-Designer\src")
sys.path.insert(1, "D:\Coding\- My -\Python\PyGubu\src")
print("path:", sys.path)

args = sys.argv
if len(args) > 1 and not args[1].endswith(".ui"):
    args.pop(1)
if len(args) < 2:
    args.append("D:\Coding\- My -\Python\WorkLog\WorkLogApp.ui")
    # args.append("D:\Programs\CloneSpy64\Result_Compare.ui")
# args += ["--loglevel", "DEBUG"]
print("argv:", args)

from pygubudesigner import main
# print(main)

if __name__ == "__main__":
    main.start_pygubu()
