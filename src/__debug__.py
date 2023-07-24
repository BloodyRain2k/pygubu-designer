import sys, pathlib, logging
PATH = pathlib.Path(__file__).parent
# sys.path.insert(1, __file__)
sys.path.insert(1, f"{PATH}")
sys.path.insert(1, f"{PATH}/../../pygubu/src")
print("path:", sys.path)

args = sys.argv
if len(args) > 1 and not args[1].endswith(".ui"):
    args.pop(1)
if len(args) < 2:
    args.append(f"{PATH}/../../Python-WorkLog/WorkLogApp.ui")
    pass
# args += ["--loglevel", "DEBUG"]
print("argv:", args)

from pygubudesigner import main
# print(main)

if __name__ == "__main__":
    main.start_pygubu()
