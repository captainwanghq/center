import os
import os.path
def copyFiles(src,des):
	currentPath = os.getcwd()
	print(currentPath)
	srcPath = os.path.join(currentPath,"src\\game")
	print(srcPath)
	files=os.listdir(srcPath)
	print(files)
copyFiles(1,2)