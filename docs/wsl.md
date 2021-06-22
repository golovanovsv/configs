## Move WSL

cd D:\
mkdir WSL
cd WSL
wsl --export Ubuntu ubuntu.tar
wsl --unregister Ubuntu
mkdir Ubuntu
wsl --import Ubuntu Ubuntu ubuntu.tar
