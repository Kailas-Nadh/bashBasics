# Some fun commands to try in Linux

# 1. To add your name at the beginning of every session in Linux Terminal
# Install packages figlet and lolcat first
# Add the below line in .bashrc and restart the terminal

figlet -f mono9 "Your name here" | lolcat 

#2. To replace name and machine name with a symbol such as ">" as terminal prompt
# Add the line in .bashrc and restart the terminal

export PS1='> '
