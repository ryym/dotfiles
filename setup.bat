@echo off

echo This batch must be executed as administrator (to 'mklink').
set /p ans=Are you administrator? (Y/n)
if "%ans%" == "n" (
    echo Cancelled.
    set ans=
    exit /b
)

pushd "%0\.."

mklink ..\.gitconfig dotfiles\.gitconfig
mklink /d ..\vimfiles dotfiles\.vim
mklink ..\.ideavimrc dotfiles\.ideavimrc
mklink ..\.vimperatorrc dotfiles\.vimperatorrc

echo Installed.
pause

popd
