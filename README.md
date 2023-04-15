# 42AI-conda-autoinstall

After having some issues with the 42AI conda install script provided on the first exercise of Python Module 00. I decided to modify it to solve mainly these issues:

- Having to run it everytime I changed computers on the 42 clusters.
- Multiple different errors when ran on Linux machines.
- Not being POSIX-compliant unnecessarily, making it more prone to compatibility issues.
- Requiring root access to run on Linux computers("/goinfre/" is write protected on Linux by default)

## This script should

- Run perfectly on either MacOS or Linux computers and on any POSIX-compliant shell(ie. bash, zsh, dash, etc).
- Not need to be ran multiple times in any circumstances.
- Not need to be ran as root on neither MacOS nor Linux computers.

### **If you have any issues, please open one here on GitHub. Also, pull requests are very welcome.**
