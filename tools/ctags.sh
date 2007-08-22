find . -type f -name "*.[hc]" -exec ctags -u {} \;
find . -type f -name "*.cpp" -exec ctags -u {} \;
find . -type f -name "*.hpp" -exec ctags -u {} \;
